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
                builder: ( BuildContext context) => HomeScreen()
            )
        );
      });
    }else{
      await Future.delayed(Duration(seconds: 3),(){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: ( BuildContext context) => LoginScreen()
            )
        );
      });
    }
  }
  @override
  void initState() {
    super.initState();
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
