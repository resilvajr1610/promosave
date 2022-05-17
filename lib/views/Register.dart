import 'package:cloud_firestore/cloud_firestore.dart';

import '../Utils/export.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Register> {

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerPasswordConfirm = TextEditingController();
  TextEditingController _controllerAddress = TextEditingController();
  TextEditingController _controllerCPF = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  UserRegister _userRegister = UserRegister();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool check = false;
  String _error="";

  _saveData(UserRegister userRegister){
    db.collection("user").doc(userRegister.idUser).set(_userRegister.toMap()).then((_)
    => Navigator.pushReplacementNamed(context, "/home"));
  }

  _createUser()async{

    if(_controllerName.text.isNotEmpty&&_controllerName.text.contains(" ")){
      if (_controllerEmail.text.isNotEmpty) {
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

            _userRegister.idUser = user.uid;
            _userRegister.name = _controllerName.text;
            _userRegister.address=_controllerAddress.text;
            _userRegister.phone=_controllerPhone.text;
            _userRegister.cpf=_controllerCPF.text;
            _userRegister.email=_controllerEmail.text;

            _saveData(_userRegister);
          });
        }on FirebaseAuthException catch (e) {
          if(e.code =="weak-password"){
            setState(() {
              _error = "Digite uma senha mais forte!";
            });
          }else if(e.code =="unknown"){
            setState(() {
              _error = "A senha está vazia!";
            });
          }else if(e.code =="invalid-email"){
            setState(() {
              _error = "Digite um e-mail válido!";
            });
          }else if(e.code =="email-already-in-use"){
            setState(() {
              _error = "Esse e-mail já está cadastrado!";
            });
          }else{
            setState(() {
              _error = e.code;
            });
          }
        }
      } else {
        setState(() {
          _error = "Preencha seu email";
        });
      }
    }else{
      setState(() {
        _error = "Preencha seu nome e Sobrenome";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return MediaQuery.of(context).size.width<700? Scaffold(
      key: _scaffoldKey,
      backgroundColor: PaletteColor.scaffold,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: Image.asset('assets/logo.png',height: 100,),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Crie sua conta',style: TextStyle(color: PaletteColor.primaryColor,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              InputRegister(
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: false,
                controller: _controllerName,
                hint: 'Nome completo',
                fonts: 14,
                keyboardType: TextInputType.text,
              ),
              InputRegister(
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: false,
                controller: _controllerAddress,
                hint: 'Endereço',
                fonts: 14,
                keyboardType: TextInputType.text,
              ),
              InputRegister(
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: false,
                controller: _controllerCPF,
                hint: 'CPF',
                fonts: 14,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter()
                ],
              ),
              InputRegister(
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: false,
                controller: _controllerPhone,
                hint: 'Número celular',
                fonts: 14,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter()
                ],
              ),
              InputRegister(
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: false,
                controller: _controllerEmail,
                hint: 'E-mail',
                fonts: 14,
                keyboardType: TextInputType.emailAddress,
              ),
              InputRegister(
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: true,
                controller: _controllerPassword,
                hint: 'Senha',
                fonts: 14,
                keyboardType: TextInputType.visiblePassword,
              ),
              InputRegister(
                icons: Icons.height,
                colorIcon: Colors.white,
                width: width*0.8,
                obscure: true,
                controller: _controllerPasswordConfirm,
                hint: 'Confirme sua senha',
                fonts: 14,
                keyboardType: TextInputType.visiblePassword,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Buttons(
                  onPressed: ()=>_createUser(),
                  text: "Criar conta",
                  size: 0,
                  colorButton: PaletteColor.primaryColor,
                  colorIcon: PaletteColor.white,
                  colorText: PaletteColor.white,
                ),
              ),
              Text(_error,style: TextStyle(color: Colors.red),)
            ],
          ),
        ),
      ),
    ):Scaffold(body: Center(child: Text('Em desenvolvimento')));
  }
}