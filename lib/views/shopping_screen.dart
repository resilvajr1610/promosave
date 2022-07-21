import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:http/http.dart' as http;
import '../models/shopping_model.dart';
import '../utils/export.dart';

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
  List titleRadio=['Para entrega','Retirada no local'];
  List titleRadioAddress=['Casa - Rua Antonio Almeida, 55, Centro São Paulo/SP','Trabalho - Avenida Monteiro Lobato, 130, Parque Alagoas - São Paulo/SP'];
  String selectedText='Para entrega';
  String selectedTextAddress='Casa - Rua Antonio Almeida, 55, Centro São Paulo/SP';
  int selectedRadioButton=0;
  int selectedRadioButtonAddress=0;
  String _publicKey = "TEST-bcf6f11a-2a2b-4126-a324-de528297749d";
  String _idPagamento='';

  _data(){
    contSalgada = widget.args.quantSalgada;
    contMista = widget.args.quantMista;
    contDoce = widget.args.quantDoce;
    valueDoce = double.parse(widget.args.byPriceSalgada.replaceAll('R\$ ', '').replaceAll(",", "."));
    valueMista = double.parse(widget.args.byPriceMista.replaceAll('R\$ ', '').replaceAll(",", "."));
    valueSalgada = double.parse(widget.args.byPriceSalgada.replaceAll('R\$ ', '').replaceAll(",", "."));
    totalDoce = contDoce*valueDoce;
    totalMista = contMista*valueMista;
    totalSalgada = contSalgada*valueSalgada;
    total = totalSalgada + totalMista + totalDoce + widget.args.feesKm;
  }

  _saveShopping()async{

    _shoppingModel.idUser=FirebaseAuth.instance.currentUser!.uid;
    _shoppingModel.quantSalgada= widget.args.quantSalgada;
    _shoppingModel.quantMista= widget.args.quantMista;
    _shoppingModel.quantDoce= widget.args.quantDoce;
    _shoppingModel.priceSalgada=widget.args.byPriceSalgada;
    _shoppingModel.priceMista=widget.args.byPriceMista;
    _shoppingModel.priceDoce=widget.args.byPriceDoce;
    _shoppingModel.status = TextConst.SHOPPING;

    await db.collection('shopping').doc(_shoppingModel.idShopping).set(_shoppingModel.toMap());
  }

  @override
  void initState() {
    super.initState();
    _shoppingModel = ShoppingModel.createId();
    _data();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    setSelectedRadio(int value){
      setState(() {
        total = value==0?total + widget.args.feesKm:total - widget.args.feesKm;
        selectedRadioButton = value;
        selectedText = titleRadio[value];
        print(selectedText);
      });
    }

    setSelectedRadioAddress(int value){
      setState(() {
        selectedRadioButtonAddress = value;
        selectedTextAddress = titleRadioAddress[value];
        print(selectedTextAddress);
      });
    }

    void launchGoogleMaps(double lat, double lng) async {
      var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
      var fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
      try {
        bool launched = await launch(url, forceSafariVC: false, forceWebView: false);
        if (!launched) {
          await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
        }
      } catch (e) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    }

    Future<void> _getPagamento()async{
      var res = await http.post(Uri.parse("https://api.mercadopago.com/checkout/preferences?access_token=TEST-2683868701623096-072020-96a1e551de175cc6875591aff881addf-10733880"),
          body: jsonEncode(
              {
                "items": [
                  {
                    "title": "Promo Save",
                    "description": "Acesso Mensal MedQuest",
                    "quantity": 1,
                    "currency_id": "ARS",
                    "unit_price": total
                  }
                ],
                "payer": {
                  "email": "medquest@medquest.com"
                }
              }
          )
      );
      //print(res.body);
      var json = jsonDecode(res.body);
      _idPagamento = json['id'];
    }

    _salvarPagamento()async{

      // Usuario usuario = Usuario();
      //
      // usuario.pagamento = pagamento;
      // usuario.dataPagamento = DateTime.now().toString();
      // FirebaseAuth auth = FirebaseAuth.instance;
      // FirebaseUser usuarioLogado = await auth.currentUser();
      // _idUsuarioLogado = usuarioLogado.uid;
      // Firestore db = Firestore.instance;
      // Map<String,dynamic> dadosAtualizar = {
      //   "pagamento" : pagamento,
      //   "dataVencimento" : usuario.dataVencimento,
      //   "dataPagamento" : usuario.dataPagamento
      // };
      // db.collection("usuarios")
      //     .document(_idUsuarioLogado)
      //     .updateData(dadosAtualizar);

      Navigator.pushReplacementNamed(context,'/splash');
    }

    return Scaffold(
      bottomSheet: BottomSheetCustom(
        text: 'Pagamento',
        sizeIcon: 0.0,
        onTap: ()async{
          _getPagamento();
          PaymentResult result =
              await MercadoPagoMobileCheckout.startCheckout(
            _publicKey,
            _idPagamento,
          );
          //print(result.toString());
          if(result.status == "approved"){
            //print("SAIDA : " + result.status.toString());
            _salvarPagamento();
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
                child: RatingCustom(rating: 4.0),
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
                    width: width * 0.6,
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
                    width: width * 0.6,
                    child: TextCustom(
                        text: 'Endereço : ' + widget.args.address,
                        fontWeight: FontWeight.normal,
                        color: PaletteColor.grey,
                        size: 12.0,
                        textAlign: TextAlign.start),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: width * 0.6,
                    child: TextCustom(
                        text: 'Taxa de entrega : R\$ ${widget.args.feesKm.toStringAsFixed(2).replaceAll('.', ',')}',
                        fontWeight: FontWeight.normal,
                        color: PaletteColor.grey,
                        size: 12.0,
                        textAlign: TextAlign.start),
                  ),
                ],
              ),
              GestureDetector(
                onTap: ()=>launchGoogleMaps(widget.args.lat, widget.args.lgn),
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
                    text: ('R\$ ${widget.args.feesKm.toStringAsFixed(2).replaceAll('.', ',')}'),
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
            height: 70,
            width: width,
            child: ListView.builder(
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
                          margin: const EdgeInsets.only(top: 15.0),
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
    );
  }
}
