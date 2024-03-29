import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:promosavecliente/service/local_push_notitication.dart';
import 'package:provider/provider.dart';
import '../models/notification_model.dart';
import '../service/app_settings.dart';
import '../utils/export.dart';
import 'package:http/http.dart' as http;

import 'first_acess_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String token = '';
  String start = '';

  readAcess(){
    start = context.watch<AppSettings>().acess;
    setState(() {});
  }

  storeNotificationToken()async{
    token = (await FirebaseMessaging.instance.getToken())!;
    FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid)
      .set({
        'token' : token
      },SetOptions(merge: true));
  }

  _mockCheckForSession()async{
    if(FirebaseAuth.instance.currentUser!=null){
      await Future.delayed(Duration(seconds: 3),(){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: ( BuildContext context) => NavigationScreen()
            )
        );
      });
    }else{
      await Future.delayed(Duration(seconds: 3),(){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: ( BuildContext context) => InitialScreen()
            )
        );
      });
    }
  }

  permissoes() async {
    var galeriaStatus = await Permission.accessMediaLocation.status;
    var notificacao = await Permission.notification.status;
    var imagem = await Permission.storage.status;
    var internet = await Permission.photos.status;
    var localizacao = await Permission.location.status;
    var localizacaoSegundoPlano = await Permission.locationAlways.status;

    if (!galeriaStatus.isGranted)
      await Permission.accessMediaLocation.request();
    if (!notificacao.isGranted) await Permission.notification.request();
    if (!imagem.isGranted) await Permission.storage.request();
    if (!internet.isGranted) await Permission.photos.request();
    if (!localizacao.isGranted) await Permission.location.request();
    if (!localizacaoSegundoPlano.isGranted)
      await Permission.locationAlways.request();
  }

  verificarion()async{
    await Future.delayed(Duration(seconds: 3),(){
      if(start==''){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: ( BuildContext context) => FirstAcessScreen()
              )
          );
      }else{
        _mockCheckForSession();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    storeNotificationToken();
    permissoes();
    verificarion();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    readAcess();

    return Scaffold(
        backgroundColor: PaletteColor.primaryColor,
        body: Center(
          child: SizedBox(
            height: height*0.5,
            width: height*0.5,
            child:Image.asset("assets/image/logo.png"),
          ),
        )
    );
  }
}
