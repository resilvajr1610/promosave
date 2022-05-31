import '../utils/export.dart';

class DefinitionScreen extends StatefulWidget {
  const DefinitionScreen({Key? key}) : super(key: key);

  @override
  _DefinitionScreenState createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends State<DefinitionScreen> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: PaletteColor.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: height*0.05),
              SizedBox(
                height: height*0.35,
                width: height*0.35,
                child:Image.asset("assets/image/logo_light.png"),
              ),
              SizedBox(height: height*0.05),
              TextCustom(
                text: 'BEM VINDO!',
                size: 16.0,
                color: PaletteColor.grey,
                fontWeight: FontWeight.bold
              ),
              SizedBox(height: height*0.02),
              TextCustom(
                text:'“Juntos contra o desperdício”',
                size: 16.0,
                color: PaletteColor.grey,
                fontWeight: FontWeight.bold
              ),
              SizedBox(height: height*0.06),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Buttons(
                  onPressed: ()=>Navigator.pushNamed(context, '/enterprise'),
                  text: "Sou uma loja",
                  size: 0,
                  colorButton: PaletteColor.primaryColor,
                  colorText: PaletteColor.white,
                  colorBorder:PaletteColor.primaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Buttons(
                  onPressed: (){},
                  text: "Sou um entregador",
                  size: 0,
                  colorButton: PaletteColor.primaryColor,
                  colorText: PaletteColor.white,
                  colorBorder:PaletteColor.primaryColor,
                ),
              ),
            ],
          ),
        )
    );
  }
}
