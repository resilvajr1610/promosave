import 'package:geolocator/geolocator.dart';
import '../models/shopping_model.dart';
import '../utils/export.dart';

class ProductsScreen extends StatefulWidget {
  Arguments args;

  ProductsScreen({required this.args});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _controllerItems = StreamController<QuerySnapshot>.broadcast();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List _allResults = [];
  int quantSalgada=0;
  int quantDoce=0;
  int quantMista=0;
  String byPriceSalgada='0';
  String byPriceMista='0';
  String byPriceDoce='0';
  double feesKm=0.0;
  double distanceFees=0.0;
  double total=0.0;
  int quantBagDoce =0;
  int quantBagMista =0;
  int quantBagSalgada =0;
  String idProduct = '';
  int available = 0;
  int selectItem = 0;

  String homeAddress = "";
  String homeCity = "";
  String homeVillage = "";
  String homeStreet = "";
  double homeLat = 0.0;
  double homeLng = 0.0;

  String workAddress = "";
  String workCity = "";
  String workVillage = "";
  String workStreet = "";
  double workLat = 0.0;
  double workLng = 0.0;

  String otherAddress = "";
  String otherCity = "";
  String otherVillage = "";
  String otherStreet = "";
  double otherLat = 0.0;
  double otherLng = 0.0;

  _dataProducts() async {
    var data = await db
        .collection("products")
        .where('idUser', isEqualTo: widget.args.idEnterprise)
        .get();

    setState(() {
      _allResults = data.docs;
    });
    return "complete";
  }

  _dataUser() async {
    DocumentSnapshot snapshot = await db
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    setState(() {
      homeAddress = data?["homeAddress"]??"";
      homeCity = data?["homeCity"]??"";
      homeLat = data?["homeLat"]??0.0;
      homeLng = data?["homeLng"]??0.0;
      homeVillage = data?["homeVillage"]??"";
      homeStreet = data?["homeStreet"]??"";

      workAddress = data?["workAddress"]??"";
      workCity = data?["workCity"]??"";
      workLat = data?["workLat"]??0.0;
      workLng = data?["workLng"]??0.0;
      workVillage = data?["workVillage"]??"";
      workStreet = data?["workStreet"]??"";

      otherAddress = data?["otherAddress"]??"";
      otherCity = data?["otherCity"]??"";
      otherLat = data?["otherLat"]??0.0;
      otherLng = data?["otherLng"]??0.0;
      otherVillage = data?["otherVillage"]??"";
      otherStreet = data?["otherStreet"]??"";
      _feesFirebase(homeLat,homeLng);
    });
  }

  _feesFirebase(homeLat,homeLng)async{
    DocumentSnapshot snapshot = await db
        .collection("fees").doc('fees').get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      feesKm = double.parse(data?["feesKm"].replaceAll(',', '.'));
    });
    _fees(homeLat,homeLng,feesKm);
  }

  _fees(double lat, double long,feesKm)async{

    double distance = await Geolocator.distanceBetween(widget.args.lat,widget.args.lgn,lat,long);
    distanceFees = distance /1000;
    setState(() {
      total = distanceFees*feesKm;
    });
  }

  void launchGoogleMaps() async {
    var url = 'google.navigation:q=${widget.args.lat.toString()},${widget.args.lgn.toString()}';
    var fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=${widget.args.lat.toString()},${widget.args.lgn.toString()}';
    try {
      bool launched = await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  @override
  void initState() {
    super.initState();
    _dataProducts();
    _dataUser();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: _scaffoldKey,
        bottomSheet: BottomSheetCustom(
          text: 'Meu carrinho',
          sizeIcon: 30.0,
          onTap: () {
            if(quantSalgada>0 || quantMista>0 || quantDoce>0){

              print(widget.args.lat);
              print(widget.args.lgn);

              Arguments args = Arguments(
                idProduct: idProduct,
                available: available,
                idEnterprise: widget.args.idEnterprise,
                banner: widget.args.banner,
                enterpriseName:  widget.args.enterpriseName,
                enterprisePicture:  widget.args.enterprisePicture,
                status: widget.args.status,
                startHours:  widget.args.startHours,
                finishHours :widget.args.finishHours,
                address:  widget.args.address,
                quantMista: quantMista,
                quantDoce: quantDoce,
                quantSalgada: quantSalgada,
                byPriceSalgada: byPriceSalgada,
                byPriceDoce: byPriceDoce,
                byPriceMista:byPriceMista,
                lat: widget.args.lat,
                lgn: widget.args.lgn,
                feesKm: feesKm,
                homeAddress: homeAddress,
                homeCity: homeCity,
                homeVillage: homeVillage,
                homeStreet: homeStreet,
                homeLat: homeLat,
                homeLng: homeLng,
                workAddress: workAddress,
                workCity: workCity,
                workVillage: workVillage,
                workStreet: workStreet,
                workLat: workLat,
                workLng: workLng,
                otherAddress: otherAddress,
                otherCity: otherCity,
                otherVillage: otherVillage,
                otherStreet: otherStreet,
                otherLat: otherLat,
                otherLng: otherLng,
                quantBagDoce: quantBagDoce,
                quantBagMista: quantBagMista,
                quantBagSalgada: quantBagSalgada,
                medRating: widget.args.medRating
              );

              Navigator.pushNamed(context, '/shopping',arguments: args);

            }else{
              showSnackBar(context, 'Seu carrinho está vázio', _scaffoldKey);
            }
          },
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.bottomRight,
              height: 120,
              width: width,
              decoration: BoxDecoration(
                color: PaletteColor.grey,
                image: DecorationImage(
                  image: NetworkImage(widget.args.banner != ""
                      ? widget.args.banner
                      : TextConst.BANNER),
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
              ),
              child: BackButtom(
                onTap: ()async{
                  Navigator.pop(context);
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: PaletteColor.primaryColor,
                    backgroundImage: NetworkImage(
                        widget.args.enterprisePicture != ""
                            ? widget.args.enterprisePicture
                            : TextConst.LOGO),
                  ),
                ),
                Container(
                  width: width*0.35,
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: TextCustom(
                      maxLines: 2,
                      fontWeight: FontWeight.bold,
                      color: PaletteColor.grey,
                      text: widget.args.enterpriseName.toUpperCase(),
                      size: 14.0,
                      textAlign: TextAlign.start),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: RatingCustom(rating: widget.args.medRating),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    widget.args.status != "-"
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: width * 0.65,
                            child: TextCustom(
                                text: widget.args.status +
                                    " - " +
                                    widget.args.startHours +
                                    " às " +
                                    widget.args.finishHours,
                                fontWeight: FontWeight.normal,
                                color: PaletteColor.primaryColor,
                                size: 12.0,
                                textAlign: TextAlign.start),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: width * 0.65,
                      child: TextCustom(
                          text: 'Endereço : ' + widget.args.address,
                          fontWeight: FontWeight.normal,
                          color: PaletteColor.grey,
                          size: 12.0,
                          textAlign: TextAlign.start),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: width * 0.65,
                      child: TextCustom(
                          text: 'Taxa de entrega : R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
                          fontWeight: FontWeight.normal,
                          color: PaletteColor.grey,
                          size: 12.0,
                          textAlign: TextAlign.start),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: ()=>launchGoogleMaps(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: PaletteColor.primaryColor,
                          size: 25,
                        ),
                        TextCustom(
                            text: 'Ver no mapa',
                            fontWeight: FontWeight.bold,
                            color: PaletteColor.primaryColor,
                            size: 12.0,
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 50),
              alignment: Alignment.topLeft,
              height: height * 0.45,
              child: StreamBuilder(
                stream: _controllerItems.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (_allResults.length == 0) {
                        return Center(
                            child: Text(
                          'Estabelecimento não encontrado',
                          style: TextStyle(
                              fontSize: 16, color: PaletteColor.primaryColor),
                        ));
                      } else {
                        return ListView.builder(
                            itemCount: _allResults.length,
                            itemBuilder: (BuildContext context, index) {
                              DocumentSnapshot item = _allResults[index];

                              String idUser = ErrorListText(item, 'idUser');
                              idProduct = ErrorListText(item, 'idProduct');
                              available = ErrorListNumber(item, 'available');
                              final byPrice = ErrorListText(item, 'byPrice');
                              final inPrice = ErrorListText(item, 'inPrice');
                              final description = ErrorListText(item, 'description');
                              final photoUrl = ErrorListText(item, 'photoUrl');
                              final product = ErrorListText(item, 'product');
                              final quantBag = ErrorListNumber(item, 'quantBag');

                              return CardProducts(
                                onTapMore: (){
                                  setState(() {
                                    if(widget.args.status !='Fechado'){
                                      if(product=="Salgada"){
                                        if(available>quantSalgada){
                                          quantSalgada=quantSalgada+1;
                                          byPriceSalgada = byPrice;
                                          quantBagSalgada = quantBag*quantSalgada;
                                         setState(() {
                                           selectItem = quantSalgada;
                                         });
                                          print(selectItem);
                                        }
                                      }
                                      if(product=="Mista"){
                                        if(available>quantMista){
                                          quantMista=quantMista+1;
                                          byPriceMista = byPrice;
                                          quantBagMista = quantBag*quantMista;
                                          setState(() {
                                            selectItem = quantMista;
                                          });
                                          print(selectItem);
                                        }
                                      }
                                      if(product=="Doce"){
                                        if(available>quantDoce){
                                          quantDoce=quantDoce+1;
                                          byPriceDoce = byPrice;
                                          quantBagDoce = quantBag*quantDoce;
                                          setState(() {
                                            selectItem = quantDoce;
                                          });
                                          print(selectItem);
                                        }
                                      }
                                    }else{
                                      showSnackBar(context, 'Aproveite para verificar o cardápio.\nEste estabelecimento estará fechado até as\n${widget.args.startHours} horas ', _scaffoldKey);
                                    }
                                  });
                                },
                                onTapDelete: (){
                                  setState(() {
                                    if(product=="Salgada"){
                                      if(0<quantSalgada){
                                        quantSalgada=quantSalgada-1;
                                        byPriceSalgada = byPrice*quantSalgada;
                                        selectItem = quantSalgada;
                                      }
                                    }
                                    if(product=="Mista"){
                                      if(0<quantMista){
                                        quantMista=quantMista-1;
                                        quantBagMista = quantBag*quantMista;
                                        selectItem = quantMista;
                                      }
                                    }
                                    if(product=="Doce"){
                                      if(0<quantDoce){
                                        quantDoce=quantDoce-1;
                                        quantBagDoce = quantBag*quantDoce;
                                        selectItem = quantDoce;
                                      }
                                    }
                                  });
                                },
                                available: available,
                                selectItem: selectItem,
                                byPrice: byPrice,
                                inPrice: inPrice,
                                description: description,
                                photoUrl: photoUrl,
                                product: product,
                              );
                            });
                      }
                  }
                },
              ),
            ),
          ],
        ));
  }
}
