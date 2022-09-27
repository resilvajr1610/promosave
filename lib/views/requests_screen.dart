import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:promosavecliente/models/alert_model.dart';
import '../models/error_double_model.dart';
import '../models/requests_model.dart';
import '../utils/export.dart';
import '../widgets/container_requests_client.dart';
import '../widgets/showDialogRating.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<RequestsModel> listRequests=[];
  List _allResults = [];
  double rating = 0.0;
  var controller = TextEditingController();

  data()async{
    var data = await db.collection("shopping").orderBy('order',descending: true).where('idClient', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      _allResults = data.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    data();
  }

  showRating(String idShopping) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                scrollable: true,
                title: Container(
                    alignment: Alignment.center,
                    width: width * 0.2,
                    height: height * 0.05,
                    child: TextCustom(text: 'Avalie',
                      color: PaletteColor.grey,
                      size: 20.0,
                      fontWeight: FontWeight.bold,)
                ),
                titleTextStyle: TextStyle(
                    color: PaletteColor.primaryColor, fontSize: 20),
                content: Row(
                  children: [
                    Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SmoothStarRating(
                              color: PaletteColor.star,
                              borderColor: PaletteColor.greyInput,
                              rating: rating,
                              onRatingChanged: (val) {
                                setState(() {
                                  rating = val;
                                  print(rating);
                                });
                              },
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: width,
                              height: height * 0.1,
                              child: TextCustom(
                                textAlign: TextAlign.center,
                                text: 'Deixe o seu comentário',
                                color: PaletteColor.grey,
                                maxLines: 1,
                              ),
                            ),
                            InputRegister(
                              controller: controller,
                              hint: 'Opicional',
                              fonts: 14.0,
                              width: width,
                            )
                          ],
                        )
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                actions: [
                  ButtonCustom(
                      onPressed: () {
                        if(controller.text.isEmpty){
                          setState(() {
                            controller.text = '';
                          });
                        }
                        db.collection('shopping').doc(idShopping).update({

                          'ratingText'  :controller.text,
                          'ratingDouble':rating

                        }).then((value) => Navigator.pushReplacementNamed(context, '/splash'));

                      },
                      text: 'Enviar',
                      size: 12.0,
                      customWidth: 0.2,
                      customHeight: 0.05,
                      colorButton: PaletteColor.primaryColor,
                      colorText: PaletteColor.white,
                      colorBorder: PaletteColor.primaryColor
                  )
                ],
              );
            });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!,
        photo: FirebaseAuth.instance.currentUser!.photoURL,
        showLower: true,
      ),
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: Image.asset(
          'assets/image/logo.png',
          height: 60,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  width: width,
                  child: TextCustom(
                      text: 'Meus pedidos',color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center
                  )
              ),
              Container(
                height: height*0.63,
                child: ListView.builder(
                  itemCount: _allResults.length,
                    itemBuilder:(context,index){

                      DocumentSnapshot item = _allResults[index];

                      if(_allResults.length == 0){
                        return Center(
                            child: Text('Nenhum pedido encontrado',
                              style: TextStyle(fontSize: 16,color: PaletteColor.primaryColor),)
                        );
                      }else{
                        listRequests.add(
                            RequestsModel(
                                showRequests: false
                            )
                        );
                        return SingleChildScrollView(
                          child: ContainerRequestsClient(
                            ratingDouble: ErrorDoubleModel(item,'ratingDouble'),
                            idRequests: item['order'],
                            date: DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item['hourRequest'])),
                            enterprise: item['nameEnterprise'].toString().toUpperCase(),
                            contMixed: item['quantMista'],
                            contSalt: item['quantSalgada'],
                            contSweet: item['quantDoce'],
                            priceDoce: item['priceDoce'],
                            priceSalgada: item['priceSalgada'],
                            priceMista: item['priceMista'],
                            type: item['type'],
                            showDetailsRequests: listRequests[index].showRequests,
                            status: item['status']!=TextConst.ORDERFINISHED?'Pendente':item['status'],
                            onTapIcon: (){
                              setState(() {
                                listRequests[index].showRequests?listRequests[index].showRequests=false:listRequests[index].showRequests=true;
                              });
                            },
                            onTapRation: ()=>showRating(item['idShopping']),
                          ),
                        );
                      }
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
