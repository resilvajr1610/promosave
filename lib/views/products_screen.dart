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

  _data() async {
    var data = await db
        .collection("products")
        .where('idUser', isEqualTo: widget.args.idUser)
        .get();

    setState(() {
      _allResults = data.docs;
    });
    return "complete";
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
        key: _scaffoldKey,
        bottomSheet: BottomSheetCustom(
          text: 'Meu carrinho',
          sizeIcon: 30.0,
          onTap: () {
            if(quantSalgada>0 || quantMista>0 || quantDoce>0){

              Arguments args = Arguments(
                  idUser: widget.args.idUser,
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
                  byPriceMista:byPriceMista
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: TextCustom(
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
                          )
                        : Container(),
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
                          text: 'Taxa de entrega : R\$ 00,00',
                          fontWeight: FontWeight.normal,
                          color: PaletteColor.grey,
                          size: 12.0,
                          textAlign: TextAlign.start),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
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
              height: height * 0.5,
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
                              String idProduct =
                                  ErrorListText(item, 'idProduct');
                              final available =
                                  ErrorListNumber(item, 'available');
                              final byPrice = ErrorListText(item, 'byPrice');
                              final inPrice = ErrorListText(item, 'inPrice');
                              final description =
                                  ErrorListText(item, 'description');
                              final photoUrl = ErrorListText(item, 'photoUrl');
                              final product = ErrorListText(item, 'product');
                              final quantBag =
                                  ErrorListNumber(item, 'quantBag');

                              return CardProducts(
                                onTapMore: (){
                                  setState(() {
                                    if(product=="Salgada"){
                                      if(available>quantSalgada){
                                        quantSalgada=quantSalgada+1;
                                        byPriceSalgada = byPrice;
                                      }
                                    }
                                    if(product=="Mista"){
                                      if(available>quantMista){
                                        quantMista=quantMista+1;
                                        byPriceMista = byPrice;
                                      }
                                    }
                                    if(product=="Doce"){
                                      if(available>quantDoce){
                                        quantDoce=quantDoce+1;
                                        byPriceDoce = byPrice;
                                      }
                                    }
                                  });
                                },
                                onTapDelete: (){
                                  setState(() {
                                    if(product=="Salgada"){
                                      if(0<quantSalgada){
                                        quantSalgada=quantSalgada-1;
                                        byPriceSalgada = byPrice;
                                      }
                                    }
                                    if(product=="Mista"){
                                      if(0<quantMista){
                                        quantMista=quantMista-1;
                                        byPriceMista = byPrice;
                                      }
                                    }
                                    if(product=="Doce"){
                                      if(0<quantDoce){
                                        quantDoce=quantDoce-1;
                                        byPriceDoce = byPrice;
                                      }
                                    }
                                  });
                                },
                                available: available,
                                selectItem: product=="Salgada"?product=="Mista"?quantDoce:quantSalgada:quantMista,
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