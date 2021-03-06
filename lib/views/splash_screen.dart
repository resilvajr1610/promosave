import '../utils/export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

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

  @override
  void initState() {
    super.initState();
    permissoes();
    _mockCheckForSession();
  }


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

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
