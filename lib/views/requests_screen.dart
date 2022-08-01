import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:promosave/widgets/container_requests_client.dart';

import '../models/requests_model.dart';
import '../utils/export.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<RequestsModel> listRequests=[];
  List _allResults = [];

  data()async{
    var data = await db.collection("shopping").where('idClient', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      _allResults = data.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    data();
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
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: Image.asset(
          'assets/image/logo.png',
          height: 100,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
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
                      return ContainerRequestsClient(
                        idRequests: item['order'],
                        date: DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item['hourRequest'])),
                        enterprise: item['nameEnterprise'].toString().toUpperCase(),
                        contMixed: item['quantMista'],
                        contSalt: item['quantSalgada'],
                        contSweet: item['quantDoce'],
                        type: item['type'],
                        showDetailsRequests: listRequests[index].showRequests,
                        status: item['status']==TextConst.ORDERCREATED?'Pendente':item['status'],
                        onTapIcon: (){
                          setState(() {
                            listRequests[index].showRequests?listRequests[index].showRequests=false:listRequests[index].showRequests=true;
                          });
                        },
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
