import '../utils/export.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<RegisterScreen>  with SingleTickerProviderStateMixin{

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerPasswordConfirm = TextEditingController();
  TextEditingController _controllerCPF = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  UserModel _userModel = UserModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool visibiblePassword = false;
  String _error="";

  _saveData(UserModel userModel){
    db.collection("user").doc(userModel.idUser).set(_userModel.toMap()).then((_)
    => Navigator.pushReplacementNamed(context, "/profile"));
  }

  _createUser()async{

    if(_controllerName.text.isNotEmpty&&_controllerName.text.contains(" ")){
      setState(() {
        _error = "";
      });
      if (_controllerCPF.text.length>10) {
        setState(() {
          _error = "";
        });
        if(_controllerPhone.text.length>7){
          setState(() {
            _error = "";
          });
          if(_controllerPassword.text == _controllerPasswordConfirm.text && _controllerPassword.text.isNotEmpty){
            setState(() {
              _error = "";
            });

            try{
              await _auth.createUserWithEmailAndPassword(
                  email: _controllerEmail.text,
                  password: _controllerPassword.text
              ).then((auth)async{

                User user = FirebaseAuth.instance.currentUser!;
                user.updateDisplayName(_controllerName.text);

                _userModel.idUser = user.uid;
                _userModel.name = _controllerName.text;
                _userModel.phone=_controllerPhone.text;
                _userModel.cpf=_controllerCPF.text;
                _userModel.email=_controllerEmail.text;

                _saveData(_userModel);
              });
            }on FirebaseAuthException catch (e) {
              if(e.code =="weak-password"){
                setState(() {
                  _error = "Digite uma senha mais forte!";
                  showSnackBar(context, _error,_scaffoldKey);
                });
              }else if(e.code =="unknown"){
                setState(() {
                  _error = "A senha está vazia!";
                  showSnackBar(context, _error,_scaffoldKey);
                });
              }else if(e.code =="invalid-email"){
                setState(() {
                  _error = "Digite um e-mail válido!";
                  showSnackBar(context, _error,_scaffoldKey);
                });
              }else if(e.code =="email-already-in-use"){
                setState(() {
                  _error = "Esse e-mail já está cadastrado!";
                  showSnackBar(context, _error,_scaffoldKey);
                });
              }else{
                setState(() {
                  _error = e.code;
                });
              }
            }

          }else{
            setState(() {
              _error = 'Senhas diferentes';
              showSnackBar(context, _error,_scaffoldKey);
            });
          }
        }else{
          setState(() {
            _error = 'Confira o número do telefone';
            showSnackBar(context, _error,_scaffoldKey);
          });
        }
      } else {
        setState(() {
          _error = "Confira o CPF";
          showSnackBar(context, _error,_scaffoldKey);
        });
      }
    }else{
      setState(() {
        _error = "Confira se o seu nome está completo";
        showSnackBar(context, _error,_scaffoldKey);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: TextCustom(text: 'Cadastro',size: 24.0,color: PaletteColor.white,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: TextCustom(text: 'Olá, crie a sua conta!',color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'Nome',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center),
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.8,
                obscure: false,
                controller: _controllerName,
                hint: 'Nome completo',
                fonts: 14.0,
                keyboardType: TextInputType.text,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'CPF',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center),
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.8,
                obscure: false,
                controller: _controllerCPF,
                hint: '000.000.000-00',
                fonts: 14.0,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter()
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'Telefone',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center),
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.8,
                obscure: false,
                controller: _controllerPhone,
                hint: '(XX) XXXXX-XXXX',
                fonts: 14.0,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter()
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'E - mail',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center),
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.8,
                obscure: false,
                controller: _controllerEmail,
                hint: 'E-mail',
                fonts: 14.0,
                keyboardType: TextInputType.emailAddress,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'Senha',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center),
              ),
              InputPassword(
                showPassword: visibiblePassword,
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: visibiblePassword,
                controller: _controllerPassword,
                hint: '********',
                fonts: 14.0,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'Confirmar Senha',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center),
              ),
              InputPassword(
                showPassword: visibiblePassword,
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: visibiblePassword,
                controller: _controllerPasswordConfirm,
                hint: '********',
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonCustom(
                  onPressed: ()=>_createUser(),
                  text: "Criar conta",
                  size: 0,
                  colorButton: PaletteColor.primaryColor,
                  colorText: PaletteColor.white,
                  colorBorder: PaletteColor.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}