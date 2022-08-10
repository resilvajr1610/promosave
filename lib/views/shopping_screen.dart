import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import '../models/shopping_model.dart';
import '../utils/export.dart';
import 'package:geolocator/geolocator.dart';

class ShoppingScreen extends StatefulWidget {
  Arguments args;

  ShoppingScreen({required this.args});

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  ShoppingModel _shoppingModel = ShoppingModel();
  int contSalgada=0;
  int contMista=0;
  int contDoce=0;
  double totalSalgada=0.0;
  double totalMista=0.0;
  double totalDoce=0.0;
  double valueDoce=0.0;
  double valueMista=0.0;
  double valueSalgada=0.0;
  double total=0.0;
  double totalFees=0.0;
  List titleRadio=['Para entrega','Retirada no local'];
  List titleRadioAddress=[];
  String selectedText='Para entrega';
  String selectedTextAddress='';
  int selectedRadioButton=0;
  int selectedRadioButtonAddress=0;
  String _publicKey = "APP_USR-19a87243-3673-4fc5-9db7-2ecea262033e";
  String _idPagamento='';
  String enterpriseName='';
  String productName='';
  bool isLoading=false;
  int order=0;
  String token='';

  _dataProduts()async{
    enterpriseName = widget.args.enterpriseName;
    contSalgada = widget.args.quantSalgada;
    contMista = widget.args.quantMista;
    contDoce = widget.args.quantDoce;
    valueDoce = double.parse(widget.args.byPriceDoce.replaceAll('R\$ ', '').replaceAll(",", "."));
    valueMista = double.parse(widget.args.byPriceMista.replaceAll('R\$ ', '').replaceAll(",", "."));
    valueSalgada = double.parse(widget.args.byPriceSalgada.replaceAll('R\$ ', '').replaceAll(",", "."));
    totalDoce = contDoce*valueDoce;
    totalMista = contMista*valueMista;
    totalSalgada = contSalgada*valueSalgada;

    double distance = await Geolocator.distanceBetween(widget.args.lat,widget.args.lgn,widget.args.homeLat,widget.args.homeLng);
    double  distanceFees = distance /1000;
    print(widget.args.lat);
    print(widget.args.lgn);

    setState(() {
      totalFees = distanceFees*widget.args.feesKm;
      total = totalSalgada + totalMista + totalDoce + totalFees;
      _getPagamento();
      isLoading=true;
    });

    setState(() {
      if(valueDoce!=0){
        productName = "Sacola Doce";
      }else if (valueSalgada!=0){
        productName = "Sacola Salgada";
      }else{
        productName = "Sacola Mista";
      }
    });
  }

  _loadingPay(){
    Future.delayed(Duration(seconds: 2),(){
      setState(() {
        isLoading=false;
      });
    });
  }

  _dataUser(){

    if(widget.args.homeAddress != ''){
      titleRadioAddress.add(widget.args.homeAddress);
    }
    if(widget.args.workAddress != ''){
      titleRadioAddress.add(widget.args.workAddress);
    }
    if(widget.args.otherAddress != ''){
      titleRadioAddress.add(widget.args.otherAddress);
    }
    setState(() {});
  }

  _saveShopping()async{

    double latClient =0.0;
    double lngClient =0.0;

    if(selectedRadioButtonAddress == 0){

      setState(() {
        latClient = widget.args.homeLat;
        lngClient = widget.args.homeLng;
      });

    }else if(selectedRadioButtonAddress ==1){

      setState(() {
        latClient = widget.args.workLat;
        lngClient = widget.args.workLng;
      });

    }else{

      setState(() {
        latClient = widget.args.otherLat;
        lngClient = widget.args.otherLng;
      });
    }

    _shoppingModel.order = order+1;
    _shoppingModel.hourRequest = DateTime.now().toString();
    _shoppingModel.idClient=FirebaseAuth.instance.currentUser!.uid;
    _shoppingModel.idEnterprise=widget.args.idEnterprise;
    _shoppingModel.logoUrl=widget.args.enterprisePicture;
    _shoppingModel.idDelivery='';
    _shoppingModel.nameDelivery='';
    _shoppingModel.nameClient= FirebaseAuth.instance.currentUser!.displayName!;
    _shoppingModel.nameEnterprise= widget.args.enterpriseName;
    _shoppingModel.quantSalgada= widget.args.quantSalgada;
    _shoppingModel.quantMista= widget.args.quantMista;
    _shoppingModel.quantDoce= widget.args.quantDoce;
    _shoppingModel.priceSalgada= totalSalgada;
    _shoppingModel.priceMista=totalMista;
    _shoppingModel.priceDoce=totalDoce;
    _shoppingModel.totalFees=totalFees;
    _shoppingModel.addressClient= selectedText=='Retirada no local'?'Retirada no local':selectedTextAddress;
    _shoppingModel.addressEnterprise = widget.args.address;
    _shoppingModel.latClient = selectedText=='Retirada no local'?0.0:latClient;
    _shoppingModel.lngClient = selectedText=='Retirada no local'?0.0:lngClient;
    _shoppingModel.latEnterprise = widget.args.lat;
    _shoppingModel.lngEnterprise = widget.args.lgn;
    _shoppingModel.status = TextConst.ORDERCREATED;
    _shoppingModel.type = selectedText;
    _shoppingModel.quantBagDoce = widget.args.quantBagDoce;
    _shoppingModel.quantBagMista = widget.args.quantBagMista;
    _shoppingModel.quantBagSalgada = widget.args.quantBagSalgada;
    _shoppingModel.totalPrice = total;

    int quant = 0;
    if(widget.args.quantSalgada!=0){
      setState(() {
        quant = widget.args.available - widget.args.quantSalgada;
      });
    }else if(widget.args.quantMista!=0){
      setState(() {
        quant = widget.args.available - widget.args.quantMista;
      });
    }else if(widget.args.quantDoce!=0){
      setState(() {
        quant = widget.args.available - widget.args.quantDoce;
      });
    }else{
      setState(() {
        quant = widget.args.available;
      });
    }


    await db.collection('shopping').doc(_shoppingModel.idShopping).set(_shoppingModel.toMap()).then((value)async{
      await db.collection('order').doc('order').set({'order':_shoppingModel.order}).then((value){
            db.collection('products').doc(widget.args.idProduct).update({'available' : quant})
                .then((value) => Navigator.pushReplacementNamed(context, '/splash'));
      });
    });
  }

  _getOrder()async{
    DocumentSnapshot snapshot = await db.collection('order').doc('order').get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      order = data?["order"]??0;
      print(order);
    });
    _saveShopping();
  }

  dataEnterprise()async{
    DocumentSnapshot snapshot = await db.collection("enterprise").doc(widget.args.idEnterprise).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      token = data?["token"];
      print(token);
    });
  }

  _getPagamento()async{
    var res = await http.post(Uri.parse("https://api.mercadopago.com/checkout/preferences?access_token=APP_USR-2803868319730474-072214-a7be486b98e689aaa117599f56e1b869-188747344"),
        body: jsonEncode(
            {
              "items": [
                {
                  "title": "Promo Save",
                  "description": "Empresa :${enterpriseName.toUpperCase()} \nProduto : $productName",
                  "quantity": 1,
                  "currency_id": "ARS",
                  "unit_price": total
                }
              ],
              "payer": {
                "email": "promosave@promosave.com"
              }
            }
        )
    );
    //print(res.body);
    var json = jsonDecode(res.body);
    _idPagamento = json['id']??'';
    if(res.statusCode == 201){
      _loadingPay();
    }
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

  calculateDelivery(int select)async{
    double distance=0.0;
    double distanceFees=0.0;
    if(select == 0){
      distance = await Geolocator.distanceBetween(widget.args.lat,widget.args.lgn,widget.args.homeLat,widget.args.homeLng);
      distanceFees = distance /1000;
      setState(() {
        total = 0.0;
        totalFees=0.0;
        totalFees = distanceFees*widget.args.feesKm;
        total = totalSalgada + totalMista + totalDoce + totalFees;
      });
    }else if(select ==1){
      distance = await Geolocator.distanceBetween(widget.args.lat,widget.args.lgn,widget.args.workLat,widget.args.workLng);
      distanceFees = distance /1000;
      setState(() {
        total = 0.0;
        totalFees=0.0;
        totalFees = distanceFees*widget.args.feesKm;
        total = totalSalgada + totalMista + totalDoce + totalFees;
      });
    }else{
      distance = await Geolocator.distanceBetween(widget.args.lat,widget.args.lgn,widget.args.otherLat,widget.args.otherLng);
      distanceFees = distance /1000;
      setState(() {
        total = 0.0;
        totalFees=0.0;
        totalFees = distanceFees*widget.args.feesKm;
        total = totalSalgada + totalMista + totalDoce + totalFees;
      });
    }
    _getPagamento();
    isLoading=true;
  }

  @override
  void initState() {
    super.initState();
    _shoppingModel = ShoppingModel.createId();
    _dataProduts();
    _dataUser();
    dataEnterprise();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    setSelectedRadio(int value){
      setState(() {
        total = value==0?total + totalFees:total - totalFees;
        selectedRadioButton = value;
        selectedText = titleRadio[value];
        print(selectedText);
      });
      _getPagamento();
      isLoading=true;
    }

    setSelectedRadioAddress(int value){
      setState(() {
        selectedRadioButtonAddress = value;
        selectedTextAddress = titleRadioAddress[value];
        print(selectedTextAddress);
        calculateDelivery(value);
      });
    }

    return Scaffold(
      bottomSheet: isLoading?Container(
          height: 50,
          width: width,
          color: PaletteColor.primaryColor,
          child: Transform.scale(
              scaleX: 0.1,
              scaleY: 0.7,
              child: CircularProgressIndicator(color: Colors.white,)
          )
      ):BottomSheetCustom(
        text: 'Pagamento',
        sizeIcon: 0.0,
        onTap: ()async{
          _getOrder();
          if(token!=''){
            sendNotification('Novo Pedido!','Cliente ${FirebaseAuth.instance.currentUser!.displayName}',token);
          }
          ///temporariamente comentado para testes sem mercado pago, mas função está funcionando perfeitamente
          // PaymentResult result = await MercadoPagoMobileCheckout.startCheckout(
          //   _publicKey,
          //   _idPagamento,
          // );
          // if(result.status == "approved"){
          //   _getOrder();
          // }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
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
              child:BackButtom(
                onTap: ()async{
                  await db.collection('shopping').doc(_shoppingModel.idShopping).delete();
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
                    ): Container(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: width * 0.65,
                      child: TextCustom(
                          maxLines: 3,
                          text: 'Endereço: ' + widget.args.address,
                          fontWeight: FontWeight.normal,
                          color: PaletteColor.grey,
                          size: 12.0,
                          textAlign: TextAlign.start),
                    ),
                    selectedRadioButton==0?Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: width * 0.65,
                      child: TextCustom(
                          text: 'Taxa de entrega: R\$ ${totalFees.toStringAsFixed(2).replaceAll('.', ',')}',
                          fontWeight: FontWeight.normal,
                          color: PaletteColor.grey,
                          size: 12.0,
                          textAlign: TextAlign.start),
                    ):Container(),
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
              indent: 20,
              endIndent: 20,
              height: 10,
              thickness: 2,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: width,
              child: TextCustom(
                  text: 'Meu pedido:',
                  fontWeight: FontWeight.normal,
                  color: PaletteColor.primaryColor,
                  size: 14.0,
                  textAlign: TextAlign.start
              ),
            ),
            contSalgada>0? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  TextCustom(
                      text: widget.args.quantSalgada.toString() +' x Sacola salgada',
                      fontWeight: FontWeight.normal,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                  Spacer(),
                  TextCustom(
                      text: ('R\$ ' +totalSalgada.toStringAsFixed(2).replaceAll('.', ',')),
                      fontWeight: FontWeight.normal,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                ],
              ),
            ):Container(),
            contMista>0? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  TextCustom(
                      text: widget.args.quantMista.toString() +' x Sacola mista',
                      fontWeight: FontWeight.normal,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                  Spacer(),
                  TextCustom(
                      text: ('R\$ ' +totalMista.toStringAsFixed(2).replaceAll('.', ',')),
                      fontWeight: FontWeight.normal,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                ],
              ),
            ):Container(),
            contDoce>0? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  TextCustom(
                      text: widget.args.quantDoce.toString() +' x Sacola doce',
                      fontWeight: FontWeight.normal,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                  Spacer(),
                  TextCustom(
                      text: ('R\$ ' +totalDoce.toStringAsFixed(2).replaceAll('.', ',')),
                      fontWeight: FontWeight.normal,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                ],
              ),
            ):Container(),
            selectedText=='Para entrega'? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Row(
                children: [
                  TextCustom(
                      text:'Taxa de entrega',
                      fontWeight: FontWeight.normal,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                  Spacer(),
                  TextCustom(
                      text: ('R\$ ${totalFees.toStringAsFixed(2).replaceAll('.', ',')}'),
                      fontWeight: FontWeight.normal,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                ],
              ),
            ):Container(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Row(
                children: [
                  TextCustom(
                      text:'Total',
                      fontWeight: FontWeight.bold,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                  Spacer(),
                  TextCustom(
                      text: ('R\$ ' +total.toStringAsFixed(2).replaceAll('.', ',')),
                      fontWeight: FontWeight.bold,
                      color: PaletteColor.grey,
                      size: 12.0,
                      textAlign: TextAlign.start
                  ),
                ],
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              height: 10,
              thickness: 2,
            ),
            Container(
              padding: EdgeInsets.only(right: 20,left: 10),
              height: 50,
              width: width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:titleRadio.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 35,
                      width: titleRadio[index]=="Para entrega"?140:200,
                      child: RadioListTile(
                        contentPadding: EdgeInsets.all(0),
                        value: index,
                        groupValue: selectedRadioButton,
                        activeColor: PaletteColor.grey,
                        title: Container(
                            height: 20,
                            margin: const EdgeInsets.only(top: 16.0),
                            child: TextCustom(text: titleRadio[index],color: PaletteColor.grey,size: 11.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start)
                        ),
                        subtitle: Text(''),
                        onChanged: (value){
                          setSelectedRadio(int.parse(value.toString()));
                        },
                      ),
                    );
                  }
              ),
            ),
            selectedText=='Para entrega'? Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: width,
              child: TextCustom(
                  text:'Endereço de entrega:',
                  fontWeight: FontWeight.normal,
                  color: PaletteColor.primaryColor,
                  size: 12.0,
                  textAlign: TextAlign.start
              ),
            ):Container(),
            selectedText=='Para entrega'? Container(
              padding: EdgeInsets.only(right: 20,left: 10,bottom: 20),
              height: height*0.4,
              width: width,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  itemCount:titleRadioAddress.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 45,
                      width: width,
                      child: RadioListTile(
                        contentPadding: EdgeInsets.all(0),
                        value: index,
                        groupValue: selectedRadioButtonAddress,
                        activeColor: PaletteColor.grey,
                        title: Container(
                            height: 60,
                            margin: const EdgeInsets.only(top: 22.0),
                            child: TextCustom(text: titleRadioAddress[index],color: PaletteColor.grey,size: 11.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start)
                        ),
                        subtitle: Text(''),
                        onChanged: (value){
                          setSelectedRadioAddress(int.parse(value.toString()));

                        },
                      ),
                    );
                  }
              ),
            ):Container(),
          ],
        ),
      ),
    );
  }
}
