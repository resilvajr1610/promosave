import '../utils/export.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: PaletteColor.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: height*0.4,
                width: height*0.4,
                child:Image.asset("assets/image/logo_light.png"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonCustom(
                  onPressed: ()=> Navigator.pushNamed(context, '/register'),
                  text: "Cadastrar",
                  size: 0,
                  colorButton: PaletteColor.primaryColor,
                  colorText: PaletteColor.white,
                  colorBorder:PaletteColor.primaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonCustom(
                  onPressed: ()=> Navigator.pushNamed(context, '/login'),
                  text: "Entrar",
                  size: 0,
                  colorButton: PaletteColor.white,
                  colorText: PaletteColor.primaryColor,
                  colorBorder:PaletteColor.primaryColor,
                ),
              ),
            ],
          ),
        )
    );
  }
}
