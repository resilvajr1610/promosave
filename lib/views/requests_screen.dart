import 'package:promosave/widgets/container_requests_client.dart';

import '../utils/export.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  bool showDetailsRequests1=false;
  bool showDetailsRequests2=false;
  bool showDetailsRequests3=false;
  bool showDetailsRequests4=false;
  bool showDetailsRequests5=false;
  bool showDetailsRequests6=false;

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
              child: ListView(
                children: [
                  ContainerRequestsClient(
                    idRequests: 0001,
                    date: '03/06/2022',
                    time: '18:00',
                    enterprise: 'Carlos Silva',
                    contMixed: 3,
                    contSalt: 0,
                    contSweet: 3,
                    type: 'Para entrega',
                    showDetailsRequests: showDetailsRequests1,
                    status: 'Pendente',
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests1==false){
                          showDetailsRequests1=true;
                        }else{
                          showDetailsRequests1=false;
                        }
                      });
                    },
                  ),
                  ContainerRequestsClient(
                    showDetailsRequests: showDetailsRequests2,
                    idRequests: 0002,
                    date: '03/06/2022',
                    time: '21:00',
                    enterprise: 'Maria Almeida',
                    contMixed: 1,
                    contSalt: 3,
                    contSweet: 0,
                    type: 'Retirada do cliente',
                    status: 'Entregue',
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests2==false){
                          showDetailsRequests2=true;
                        }else{
                          showDetailsRequests2=false;
                        }
                      });
                    },
                  ),
                  ContainerRequestsClient(
                    idRequests: 0003,
                    date: '03/06/2022',
                    time: '18:00',
                    enterprise: 'Carlos Silva',
                    contMixed: 2,
                    contSalt: 0,
                    contSweet: 3,
                    type: 'Para entrega',
                    status: 'Entregue',
                    showDetailsRequests: showDetailsRequests3,
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests3==false){
                          showDetailsRequests3=true;
                        }else{
                          showDetailsRequests3=false;
                        }
                      });
                    },
                  ),
                  ContainerRequestsClient(
                    showDetailsRequests: showDetailsRequests4,
                    idRequests: 0004,
                    date: '03/06/2022',
                    time: '21:00',
                    enterprise: 'Maria Almeida',
                    contMixed: 1,
                    contSalt: 1,
                    contSweet: 1,
                    type: 'Retirada do cliente',
                    status: 'Entregue',
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests4==false){
                          showDetailsRequests4=true;
                        }else{
                          showDetailsRequests4=false;
                        }
                      });
                    },
                  ),
                  ContainerRequestsClient(
                    idRequests: 0005,
                    date: '03/06/2022',
                    time: '18:00',
                    enterprise: 'Carlos Silva',
                    contMixed: 2,
                    contSalt: 0,
                    contSweet: 1,
                    type: 'Para entrega',
                    status: 'Entregue',
                    showDetailsRequests: showDetailsRequests5,
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests5==false){
                          showDetailsRequests5=true;
                        }else{
                          showDetailsRequests5=false;
                        }
                      });
                    },
                  ),
                  ContainerRequestsClient(
                    showDetailsRequests: showDetailsRequests6,
                    idRequests: 0006,
                    date: '03/06/2022',
                    time: '21:00',
                    enterprise: 'Maria Almeida',
                    contMixed: 1,
                    contSalt: 1,
                    contSweet: 2,
                    type: 'Retirada do cliente',
                    status: 'Entregue',
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests6==false){
                          showDetailsRequests6=true;
                        }else{
                          showDetailsRequests6=false;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
