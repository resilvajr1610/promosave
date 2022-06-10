
import 'package:promosave/models/shopping_model.dart';

import '../utils/export.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _controllerPhone = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final photo = FirebaseAuth.instance.currentUser!.photoURL;
  String urlPhotoProfile="";
  File? picture;
  bool _sending = false;

  _data()async{
    DocumentSnapshot snapshot = await db.collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid).get();
  }

  Future _savePhoto(String name) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 100);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.picture = imageTemporary;
        setState(() {
          _sending = true;
        });
        _uploadImage(name);
      });
    } on PlatformException catch (e) {
      print('Error : $e');
    }
  }

  Future _uploadImage(String name) async {
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("client").child(name+"_"+DateTime.now().toString()+".jpg");

    UploadTask task = arquivo.putFile(picture!);

    Future.delayed(const Duration(seconds: 5), () async {
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if (urlImage != null) {
        setState(() {
          urlPhotoProfile = urlImage;
          User? user = FirebaseAuth.instance.currentUser;
          user?.updatePhotoURL(urlPhotoProfile);
        });
        _urlImageFirestore(urlImage,name);
      }
    });
  }

  _urlImageFirestore(String url,String name) {

    Map<String, dynamic> dateUpdate = {
      name: url,
    };

    db
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(dateUpdate)
        .then((value) {
      setState(() {
        _sending = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _data();
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
        elevation: 0,
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: TextCustom(text: 'Perfil',size: 24.0,color: PaletteColor.white,fontWeight: FontWeight.bold,textAlign: TextAlign.center),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _sending==false? GestureDetector(
                onTap: ()=>_savePhoto('urlPhotoProfile'),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: photo==null ? CircleAvatar(
                      radius: 48,
                      backgroundColor: PaletteColor.primaryColor,
                      backgroundImage: AssetImage('assets/image/logo.png')
                  ):CircleAvatar(
                    radius: 48,
                    backgroundColor: PaletteColor.primaryColor,
                    backgroundImage: NetworkImage(photo!),
                  ),
                ),
              ):CircularProgressIndicator(),
              TextCustom(text: FirebaseAuth.instance.currentUser!.displayName!, size: 14.0, color: PaletteColor.greyInput, fontWeight: FontWeight.bold,textAlign: TextAlign.center),
              TextCustom(text: FirebaseAuth.instance.currentUser!.email!, size: 14.0, color: PaletteColor.greyInput, fontWeight: FontWeight.bold,textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xffF15622),
                                Color(0xffF8A78B),
                              ],
                            )
                        ),
                        child: Center(child: TextCustom(text: 'R\$\n20', size: 16.0, color: PaletteColor.white, fontWeight: FontWeight.w500,textAlign: TextAlign.center)),
                      ),
                      TextCustom(text: 'Dinheiro\npoupado', size: 12.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal,textAlign: TextAlign.center),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xffF15622),
                                Color(0xffF8A78B),
                              ],
                            )
                        ),
                        child: Center(child: TextCustom(text: '4', size: 24.0, color: PaletteColor.white, fontWeight: FontWeight.w500,textAlign: TextAlign.center)),
                      ),
                      TextCustom(text: 'Alimentos\nsalvos', size: 12.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal,textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),
              Container(
                width: width,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(8),
                child: TextCustom(text: 'Alterar dados :', size: 16.0, color: PaletteColor.grey, fontWeight: FontWeight.normal,textAlign: TextAlign.center)
              ),
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextCustom(text: 'Telefone', size: 14.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal,textAlign: TextAlign.center)
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.85,
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
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  child: TextCustom(text: 'Endereço', size: 14.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal,textAlign: TextAlign.center)
              ),
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child:  Row(
                    children: [
                      TextCustomAddress(
                        address: 'Rua Antonio Almeida, 55, Centro São Paulo/SP',
                        type: 'Casa',
                        width: width*0.7,
                      ),
                      Spacer(),
                      Icon(Icons.delete,color: PaletteColor.primaryColor,)
                    ],
                  )
              ),
              SizedBox(height: 10),
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child:  Row(
                    children: [
                      TextCustomAddress(
                        address: 'Avenida Monteiro Lobato, 130, Parque Alagoas - São Paulo/SP',
                        type: 'Trabalho',
                        width: width*0.7,
                      ),
                      Spacer(),
                      Icon(Icons.delete,color: PaletteColor.primaryColor,)
                    ],
                  )
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    width: width*0.6,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                        color: PaletteColor.greyLight,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: TextCustom(size: 14.0, fontWeight: FontWeight.normal, color: PaletteColor.grey, text: 'Adicionar novo endereço',textAlign: TextAlign.center),
                  ),
                  Spacer()
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonCustom(
                  onPressed: (){},
                  text: "Salvar",
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
