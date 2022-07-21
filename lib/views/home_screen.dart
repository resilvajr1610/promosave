import 'package:intl/intl.dart';
import 'package:promosave/models/error_double_model.dart';

import '../utils/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _controllerSearch = TextEditingController();
  var _controllerItems = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _resultsList = [];
  List _allResults = [];
  int productLength=0;

  _data() async {

    var data = await db.collection("enterprise").where('type', isEqualTo: TextConst.ENTERPRISE).get();

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

  @override
  void initState() {
    super.initState();
    userFirebase();
    _controllerSearch.addListener(_search);
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
                          TextCustom(text: 'Cidade - SP',fontWeight: FontWeight.normal,size: 16.0, color: PaletteColor.greyInput,textAlign: TextAlign.center,),
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
                        textAlignVertical: TextAlignVertical.center,
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextCustom(text: 'Tudo',size: 14.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                    TextCustom(text: 'Aberto',size: 14.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal,textAlign: TextAlign.center),
                    TextCustom(text: 'Favoritos',size: 14.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal,textAlign: TextAlign.center),
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
                          return ListView.builder(
                              itemCount: _resultsList.length,
                              itemBuilder: (BuildContext context, index) {
                                DocumentSnapshot item = _resultsList[index];

                                String idUser = ErrorStringModel(item,'idUser');
                                String name = ErrorStringModel(item,'name');
                                int products = ErrorListNumber(item,'products');
                                final urlPhotoProfile = ErrorStringModel(item,'urlPhotoProfile');
                                final urlPhotoBanner = ErrorStringModel(item,'urlPhotoBanner');
                                final startHours = ErrorStringModel(item,'startHours');
                                final finishHours = ErrorStringModel(item,'finishHours');
                                final address = ErrorStringModel(item,'address');
                                final lat = ErrorDoubleModel(item,'lat');
                                final lng = ErrorDoubleModel(item,'lng');
                                final now= DateTime.now();
                                int nowFormat = int.parse(DateFormat('HH').format(now));
                                var status = '-';

                                if(startHours!=""){
                                  int  startFormat = int.parse(DateFormat('HH').format(DateTime.parse("2022-06-08 "+startHours+":49.492104").toLocal()));
                                  int  finishFormat = int.parse(DateFormat('HH').format(DateTime.parse("2022-06-08 "+finishHours+":49.492104").toLocal()));
                                  if(nowFormat>startFormat && nowFormat<finishFormat){
                                      status = 'Aberto';
                                  }else{
                                    status = 'Fechado';
                                  }
                                }
                                produts(idUser);

                                Arguments args = Arguments(
                                  idUser:idUser,
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
                                  byPriceSalgada: '',
                                  byPriceDoce: '',
                                  byPriceMista:'',
                                  lat: lat,
                                  lgn: lng,
                                  feesKm: 0.0
                                );

                                return products>0? CardHome(
                                  onTap: ()=>Navigator.pushNamed(context, '/products',arguments: args),
                                  urlPhotoProfile: urlPhotoProfile,
                                  urlPhotoBanner: urlPhotoBanner,
                                  startHours: startHours,
                                  finishHours: finishHours,
                                  name: name.toUpperCase(),
                                  status: status,
                                ):Container();
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
