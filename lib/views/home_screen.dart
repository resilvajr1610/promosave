import 'package:intl/intl.dart';
import 'package:promosave/models/error_double_model.dart';
import 'package:promosave/models/error_list_model.dart';
import 'package:promosave/models/favorites_model.dart';
import 'package:promosave/models/rating_model.dart';
import '../models/notification_model.dart';
import '../utils/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _controllerSearch = TextEditingController();
  var _controllerItems = StreamController<QuerySnapshot>.broadcast();
  final _controllerCitiesBroadcast = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<FavoritesModel> listFavorites=[];
  List<RatingModel> listRating=[];
  List _resultsList = [];
  List _allResults = [];
  int productLength=0;
  String newStatus = 'Todos';
  var valueCity ='Todos';
  bool showFav=false;
  bool isLoading=false;
  DocumentSnapshot? snapshot;
  double rating=0.0;

  _data() async {

    var data = await db.collection("enterprise")
        .where('type', isEqualTo: TextConst.ENTERPRISE)
        .where('products', isNotEqualTo: 0)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    resultSearchList();
    return "complete";
  }

  _search() {
    resultSearchList();
  }
  resultSearchList() {
    var showResults = [];

    if (_controllerSearch.text != "") {
      for (var items in _allResults) {
        var brands = SearchModel.fromSnapshot(items).name.toLowerCase();

        if (brands.contains(_controllerSearch.text.toLowerCase())) {
          showResults.add(items);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  userFirebase ()async{
    String user = await FirebaseAuth.instance.currentUser!.uid;
    if( user==null){
      Navigator.pushReplacementNamed(context, "/initial");
    }else{
      _data();
    }
  }

   produts(String idUser)async{
    var data =await db.collection("products").where('idUser', isEqualTo: idUser).get();
    List _allResults = data.docs;
    productLength = _allResults.length;
    db.collection('enterprise').doc(idUser).update({'products': productLength});
  }

  Future<Stream<QuerySnapshot>?> _addListenerCities()async{

    Stream<QuerySnapshot> stream = db
        .collection("cities")
        .snapshots();

    stream.listen((data) {
      _controllerCitiesBroadcast.add(data);
    });
  }

  checkEnterprise(idEnterprise,index)async{
    snapshot = await db.collection('enterprise').doc(idEnterprise).get();
    _checkFavorites(index);
  }

  _checkFavorites(index)async{
    bool show = false;

    if(ErrorListModel(snapshot, "favorites")!=[]){
      if(ErrorListModel(snapshot, "favorites").contains(FirebaseAuth.instance.currentUser!.uid)){
        show = true;
        listFavorites.insert(index,
            FavoritesModel(
                showFavorites: show
            )
        );
      }else{
        listFavorites.insert(index,
            FavoritesModel(
                showFavorites: show
            )
        );
      }
    }
    _data();
    if(listFavorites.length==_allResults.length){
      setState(() {
        isLoading=false;
      });
    }
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
  }

  @override
  void initState() {
    super.initState();
    userFirebase();
    _controllerSearch.addListener(_search);
    _addListenerCities();
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              InputHome(
                  widget: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                          stream:_controllerCitiesBroadcast.stream,
                            builder: (context,snapshot){

                              if(snapshot.hasError)
                                return Text("Erro ao carregar dados!");

                              switch (snapshot.connectionState){
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Container();
                                case ConnectionState.active:
                                case ConnectionState.done:

                                  if(!snapshot.hasData){
                                    return CircularProgressIndicator();
                                  }else {
                                    List<DropdownMenuItem> espItems = [];
                                    for (int i = 0; i < snapshot.data!.docs.length; i++) {
                                      DocumentSnapshot snap = snapshot.data!.docs[i];
                                      espItems.add(
                                          DropdownMenuItem(
                                            child: Text(
                                              snap.id,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: snap.id=='Todos'?PaletteColor.primaryColor:PaletteColor.greyInput),
                                            ),
                                            value: "${snap.id}",
                                          )
                                      );
                                    }
                                    return Container(
                                      width: width*0.65,
                                      child: DropdownButton(
                                        underline: Container(),
                                        items: espItems,
                                        onChanged: (value) {
                                          setState(() {
                                            valueCity = value.toString();
                                          });
                                        },
                                        value: valueCity,
                                        isExpanded: true,
                                        hint: new Text(
                                          "",
                                          style: TextStyle(color: PaletteColor.greyInput,fontSize: 10),
                                        ),
                                      ),
                                    );
                                  }
                              }
                            },
                          ),
                          Spacer(),
                          Icon(Icons.location_on,size: 25,color: PaletteColor.primaryColor,),
                        ],
                      ))),
              InputHome(
                  widget: Container(
                alignment: Alignment.centerLeft,
                width: width*0.8,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controllerSearch,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(
                          color: PaletteColor.grey,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Pesquisar estabelecimento',
                            hintStyle: TextStyle(
                              color: PaletteColor.greyInput,
                              fontSize: 16.0,
                            )
                        ),
                      ),
                    ),
                    Icon(Icons.search,size: 25,color: PaletteColor.primaryColor,),
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: ()=>setState(() {
                          _data();
                          newStatus = 'Todos';
                          showFav = false;
                          isLoading=true;
                        }),
                        child: TextCustom(text: 'Todos',size: 14.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal,textAlign: TextAlign.center,)),
                    TextButton(
                        onPressed: ()=>setState(() {
                          _data();
                          newStatus = 'Fechado';
                          showFav = false;
                          isLoading=true;
                        }),
                        child: TextCustom(text: 'Aberto',size: 14.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal,textAlign: TextAlign.center)),
                    TextButton(
                        onPressed: ()=>setState((){
                          _data();
                          newStatus = 'Todos';
                          showFav = true;
                          isLoading=true;
                        }),
                        child: TextCustom(text: 'Favoritos',size: 14.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal,textAlign: TextAlign.center)),
                  ],
                ),
              ),
              Container(
                height: height*0.5,
                child: StreamBuilder(
                  stream: _controllerItems.stream,
                  builder: (context, snapshot) {

                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if(_resultsList.length == 0){
                          return Center(
                              child: Text('Estabelecimento não encontrado',
                                style: TextStyle(fontSize: 16,color: PaletteColor.primaryColor),)
                          );
                        }else {
                          return _resultsList.length == 0?CircularProgressIndicator():ListView.builder(
                              itemCount: _resultsList.length,
                              itemBuilder: (BuildContext context, index) {
                                DocumentSnapshot item = _resultsList[index];

                                String idEnterprise = ErrorStringModel(item,'idUser');
                                String name = ErrorStringModel(item,'name');
                                int products = ErrorListNumber(item,'products');
                                final urlPhotoProfile = ErrorStringModel(item,'urlPhotoProfile');
                                final urlPhotoBanner = ErrorStringModel(item,'urlPhotoBanner');
                                final startHours = ErrorStringModel(item,'startHours');
                                final finishHours = ErrorStringModel(item,'finishHours');
                                final address = ErrorStringModel(item,'address');
                                final lat = ErrorDoubleModel(item,'lat');
                                final lng = ErrorDoubleModel(item,'lng');
                                final city = ErrorStringModel(item,'city');
                                final now= DateTime.now();
                                int nowFormat = int.parse(DateFormat('HH').format(now));
                                var status = '-';

                                if(startHours!=""){
                                  int  startFormat = int.parse(DateFormat('HH').format(DateTime.parse("2022-06-08 "+startHours+":49.492104").toLocal()));
                                  int  finishFormat = int.parse(DateFormat('HH').format(DateTime.parse("2022-06-08 "+finishHours+":49.492104").toLocal()));
                                  if(nowFormat>=startFormat && nowFormat<=finishFormat){
                                    status = 'Aberto';
                                  }else{
                                    status = 'Fechado';
                                  }
                                }

                                produts(idEnterprise);

                                Arguments args = Arguments(
                                  idProduct: '',
                                  available: 0,
                                  idEnterprise:idEnterprise,
                                  banner: urlPhotoBanner,
                                  enterpriseName: name,
                                  enterprisePicture: urlPhotoProfile,
                                  status: status,
                                  startHours: startHours,
                                  finishHours :finishHours,
                                  address: address,
                                  quantMista: 0,
                                  quantDoce: 0,
                                  quantSalgada: 0,
                                  quantBagDoce: 0,
                                  quantBagMista: 0,
                                  quantBagSalgada: 0,
                                  byPriceSalgada: '',
                                  byPriceDoce: '',
                                  byPriceMista:'',
                                  lat: lat,
                                  lgn: lng,
                                  feesKm: 0.0,
                                  medRating:listRating.isEmpty ||listRating.length != index+1 ?0.0:listRating[index].medRating
                                );

                                if(listFavorites.length< _allResults.length){
                                  checkEnterprise(idEnterprise,index);
                                  _ratingEnterprise(idEnterprise,index);
                                }

                                if(products>0 && status != newStatus && (city == valueCity || valueCity =='Todos')){
                                    if(showFav){
                                      if(listFavorites[index].showFavorites){
                                        return CardHome(
                                          onTap: ()=>Navigator.pushNamed(context, '/products',arguments: args),
                                          onTapFavorite: (){
                                            db.collection('enterprise').doc(idEnterprise).update(
                                                {
                                                  'favorites': listFavorites[index].showFavorites?
                                                  FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]):
                                                  FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
                                                });
                                            setState(() {
                                              listFavorites[index].showFavorites?
                                              listFavorites[index].showFavorites=false:
                                              listFavorites[index].showFavorites=true;
                                            });
                                          },
                                          favorite: listFavorites[index].showFavorites,
                                          urlPhotoProfile: urlPhotoProfile,
                                          urlPhotoBanner: urlPhotoBanner,
                                          startHours: startHours,
                                          finishHours: finishHours,
                                          name: name.toUpperCase(),
                                          status: status,
                                          rating: listRating.isEmpty?0.0:listRating[index].medRating,
                                        );
                                      }else{
                                        return Container();
                                      }
                                    }else{
                                      return listFavorites.length!=index?CardHome(
                                        rating: listRating.isEmpty?0.0:listRating[index].medRating,
                                        onTap: ()=>Navigator.pushNamed(context, '/products',arguments: args),
                                        onTapFavorite: (){
                                          db.collection('enterprise').doc(idEnterprise).update(
                                              {
                                                'favorites': listFavorites[index].showFavorites?
                                                FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]):
                                                FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
                                              });
                                          setState(() {
                                            listFavorites[index].showFavorites?
                                            listFavorites[index].showFavorites=false:
                                            listFavorites[index].showFavorites=true;
                                            sendNotification('teste fav','fav body','${TextConst.TOKENTESTE}');
                                          });
                                        },
                                        favorite: listFavorites.isEmpty?false:listFavorites[index].showFavorites,
                                        urlPhotoProfile: urlPhotoProfile,
                                        urlPhotoBanner: urlPhotoBanner,
                                        startHours: startHours,
                                        finishHours: finishHours,
                                        name: name.toUpperCase(),
                                        status: status,
                                      ):Container();
                                    }
                                }else{
                                  return Container();
                                }
                              }
                          );
                        }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
