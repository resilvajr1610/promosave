import '../utils/export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  bool visibiblePassword = false;

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: PaletteColor.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: height*0.03),
              SizedBox(
                height: height*0.3,
                width: height*0.3,
                child:Image.asset("assets/image/logo_light.png"),
              ),
              SizedBox(height: height*0.02),
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
              Container(
                width: width*0.8,
                child: TextCustom(text: 'E - mail',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal),
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.8,
                obscure: false,
                controller: _controllerEmail,
                hint:'E - mail',
                fonts: 14.0,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: height*0.02),
              Container(
                width: width*0.8,
                child: TextCustom(text: 'Senha',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal),
              ),
              InputPassword(
                showPassword: visibiblePassword,
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: visibiblePassword,
                controller: _controllerPassword,
                hint: 'Senha',
                fonts: 14,
                keyboardType: TextInputType.visiblePassword,
                onPressed: (){
                  setState(() {
                    if(visibiblePassword==false){
                      visibiblePassword=true;
                    }else{
                      visibiblePassword=false;
                    }
                  });
                },
              ),
              SizedBox(height: height*0.03),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Buttons(
                  onPressed:(){},
                  text: "Entrar",
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
