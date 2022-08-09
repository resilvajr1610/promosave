import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/error_double_model.dart';
import '../models/rating_model.dart';
import '../utils/export.dart';


class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {

  CameraPosition _positionCamera= CameraPosition(target: LatLng(-23.609368350995943,-48.05764021588343));
  Set<Marker> _markers={};
  Completer<GoogleMapController> _controller = Completer();
  double? lat=-23.609368350995943;
  double? lon= -48.05764021588343;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _allResults=[];
  double rating=0.0;
  List<RatingModel> listRating=[];

  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  _locationProfessional(double lat, double lon)async{
    setState(() {
      _positionCamera = CameraPosition(
          target: LatLng(lat,lon),
          zoom: 16
      );
      _animationCamera(_positionCamera);
      _showMarkers(lat,lon);
    });
  }

  _showMarkers(double lat, double lon)async{

    Marker local = Marker(
        markerId:MarkerId("local"),
        position: LatLng(lat,lon),
        infoWindow: InfoWindow(title: "Local do estabelecimento"),
        icon: BitmapDescriptor.defaultMarker
    );

    setState(() {
      _markers.add(local);
    });

  }

  _animationCamera(CameraPosition cameraPosition)async{

    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition)
    );

  }

  _data() async {

    var data = await db.collection("enterprise")
        .where('type', isEqualTo: TextConst.ENTERPRISE)
        .where('status',isEqualTo: TextConst.APPROVED)
        .where('products', isNotEqualTo: 0)
        .get();

    setState(() {
      _allResults = data.docs;
    });

    print('_allResultsinit : ${_allResults.length}');
  }

  _ratingEnterprise(idEnterprise,index)async{

    // var idEnterprise = 'YddvP78LW8OjgkYCggEB6DNyBZr2';
    List _allRating = [];
    double acumula =0.0;

    var data = await db.collection("shopping")
        .where('idEnterprise', isEqualTo: idEnterprise)
        .where('ratingDouble', isNotEqualTo: 0.0)
        .get();
    _allRating = data.docs;
    if(_allRating.length != 0){
      List<DocumentSnapshot> movimentacoes = data.docs.toList();

      for (int i=0;i<_allRating.length;i++){
        DocumentSnapshot item = movimentacoes[i];
        double ratingDouble = ErrorDoubleModel(item, "ratingDouble");
        acumula += ratingDouble;
      }
      setState(() {
        rating = acumula/_allRating.length;
      });
    }else{
      setState(() {
        rating = 0.0;
      });
    }
    listRating.add(
        RatingModel(
            medRating: rating
        )
    );

    print(listRating[index].medRating);
  }

  @override
  void initState() {
    super.initState();
    _data();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!,
        photo: FirebaseAuth.instance.currentUser!.photoURL,
      ),
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: Image.asset('assets/image/logo.png',height: 100,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Container(
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: _positionCamera,
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                ),
                width: width,
                height: height*0.5,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Container(
              height: height*0.2,
              padding: EdgeInsets.only(right: 4,left: 4,top: 4,bottom: 5),
              child: ListView.builder(
                itemCount: _allResults.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {

                  DocumentSnapshot item = _allResults[index];

                  if(listRating.length< _allResults.length){
                    _ratingEnterprise(item['idUser'],index);
                    print('listRating.length $listRating.length ===  _allResults.length ${_allResults.length}');
                  }

                  return CarrosselProfessionals(
                    onTap: () {
                      setState(() {
                        _markers.clear();
                        lat = item['lat'];
                        lon = item['lng'];

                        _locationProfessional(lat!,lon!);
                      });
                    },
                    name: ErrorStringModel(item,'name'),
                    urlBanner: ErrorStringModel(item,'urlPhotoBanner'),
                    urlLogo: ErrorStringModel(item,'urlPhotoProfile'),
                    rating: listRating.isEmpty?0.0:listRating[index].medRating,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}