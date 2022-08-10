import 'package:google_place/google_place.dart';
import 'package:promosave/models/shopping_model.dart';
import '../models/alert_model.dart';
import '../models/error_double_model.dart';
import '../utils/export.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _controllerPhone = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final photo = FirebaseAuth.instance.currentUser!.photoURL;
  String urlPhotoProfile = "";
  File? picture;
  bool _sending = false;
  String phone = "";

  String homeAddress = "";
  String homeCity = "";
  String homeVillage = "";
  String homeStreet = "";
  double homeLat = 0.0;
  double homeLng = 0.0;

  String workAddress = "";
  String workCity = "";
  String workVillage = "";
  String workStreet = "";
  double workLat = 0.0;
  double workLng = 0.0;

  String otherAddress = "";
  String otherCity = "";
  String otherVillage = "";
  String otherStreet = "";
  double otherLat = 0.0;
  double otherLng = 0.0;

  double money = 0.0;
  int contSave = 0;

  _showDialog() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog();
        });
  }

  _data() async {
    DocumentSnapshot snapshot = await db
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    setState(() {
      phone = data?["phone"]??"";
      homeAddress = data?["homeAddress"]??"";
      homeCity = data?["homeCity"]??"";
      homeLat = data?["homeLat"]??0.0;
      homeLng = data?["homeLng"]??0.0;
      homeVillage = data?["homeVillage"]??"";
      homeStreet = data?["homeStreet"]??"";

      workAddress = data?["workAddress"]??"";
      workCity = data?["workCity"]??"";
      workLat = data?["workLat"]??0.0;
      workLng = data?["workLng"]??0.0;
      workVillage = data?["workVillage"]??"";
      workStreet = data?["workStreet"]??"";

      otherAddress = data?["otherAddress"]??"";
      otherCity = data?["otherCity"]??"";
      otherLat = data?["otherLat"]??0.0;
      otherLng = data?["otherLng"]??0.0;
      otherVillage = data?["otherVillage"]??"";
      otherStreet = data?["otherStreet"]??"";

      _controllerPhone = TextEditingController(text: phone);
    });
  }

  Future _savePhoto(String name,String type) async {
    final image;
    try {
     if(type=='camera'){
       image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100);
     }else{
       image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
     }
      if (image == null) return;

      Navigator.of(context).pop();


      final imageTemporary = File(image.path);
      setState(() {
        this.picture = imageTemporary;
        setState(() {
          urlPhotoProfile='';
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
    Reference arquivo = pastaRaiz
        .child("client")
        .child(name + "_" + DateTime.now().toString() + ".jpg");

    UploadTask task = arquivo.putFile(picture!);

    Future.delayed(const Duration(seconds: 5), () async {
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if (urlImage != null) {
        setState(() {
          urlPhotoProfile = urlImage;
          User? user = FirebaseAuth.instance.currentUser;
          user?.updatePhotoURL(urlPhotoProfile);
        });
        _urlImageFirestore(urlImage, name);
      }
    });
  }

  _urlImageFirestore(String url, String name) {
    Map<String, dynamic> dateUpdate = {
      name: url,
    };

    db.collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(dateUpdate)
        .then((value) {
      setState(() {
        _sending = false;
      });
    });
  }

  deleteAddress(var place){
    db.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).update({
      "${place}address":"",
      "${place}street" :"",
      "${place}village":"",
      "${place}city"   :"",
      "${place}lat"    :0.0,
      "${place}lng"    :0.0,
    }).then((value) => Navigator.pushReplacementNamed(context, '/profile'));
  }

  _moneySaved()async{

    List _allMoney = [];
    double acumulaMoney =0.0;

    var data = await db.collection("shopping")
        .where('idClient', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    _allMoney = data.docs;
    if(_allMoney.length != 0){
      List<DocumentSnapshot> movimentacoes = data.docs.toList();

      for (int i=0;i<_allMoney.length;i++){
        DocumentSnapshot item = movimentacoes[i];
        double moneyDouble = ErrorDoubleModel(item, "totalPrice");
        acumulaMoney += moneyDouble;
      }
      setState(() {
        money = acumulaMoney;
        contSave = _allMoney.length;
      });
    }else{
      setState(() {
        money = 0.0;
      });
    }
    print(money);
  }

  @override
  void initState() {
    super.initState();
    _data();
    _moneySaved();
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
        title: TextCustom(
            text: 'Perfil',
            size: 24.0,
            color: PaletteColor.white,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _sending == false
                  ? GestureDetector(
                      onTap: ()=>AlertModel().alert('Perfil !', 'Escolha uma opção para \nselecionar sua foto', PaletteColor.grey, PaletteColor.grey, context,
                          [
                            ButtonCustom(
                              onPressed: () => _savePhoto('urlPhotoProfile','camera'),
                              text: 'Câmera',
                              colorBorder: PaletteColor.greyInput,
                              colorButton: PaletteColor.greyInput,
                              colorText: PaletteColor.white,
                              size: 14.0,
                            ),
                            ButtonCustom(
                              onPressed: () => _savePhoto('urlPhotoProfile','gallery'),
                              text: 'Galeria',
                              colorBorder: PaletteColor.greyInput,
                              colorButton: PaletteColor.greyInput,
                              colorText: PaletteColor.white,
                              size: 14.0,
                            ),
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: photo == null
                            ? CircleAvatar(
                                radius: 48,
                                backgroundColor: PaletteColor.greyInput,
                                child: Icon(Icons.camera_alt,color: PaletteColor.white,size: 40,),
                            )
                            : CircleAvatar(
                                radius: 48,
                                backgroundColor: PaletteColor.primaryColor,
                                backgroundImage: NetworkImage(photo!),
                              ),
                      ),
                    )
                  : CircularProgressIndicator(),
              TextCustom(
                  text: FirebaseAuth.instance.currentUser!.displayName!,
                  size: 14.0,
                  color: PaletteColor.greyInput,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center),
              TextCustom(
                  text: FirebaseAuth.instance.currentUser!.email!,
                  size: 14.0,
                  color: PaletteColor.greyInput,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center),
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
                            )),
                        child: Center(
                            child: TextCustom(
                                text: 'R\$\n${money.toStringAsFixed(2).replaceAll('.', ',')}',
                                maxLines: 2,
                                size: 16.0,
                                color: PaletteColor.white,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center
                            )
                        ),
                      ),
                      TextCustom(
                          text: 'Dinheiro\npoupado',
                          maxLines: 2,
                          size: 12.0,
                          color: PaletteColor.primaryColor,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.center),
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
                            )),
                        child: Center(
                            child: TextCustom(
                                text: contSave.toString(),
                                size: 24.0,
                                color: PaletteColor.white,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center
                            )
                        ),
                      ),
                      TextCustom(
                          text: 'Alimentos\nsalvos',
                          maxLines: 2,
                          size: 12.0,
                          color: PaletteColor.primaryColor,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.center
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  child: TextCustom(
                      text: 'Alterar dados :',
                      size: 16.0,
                      color: PaletteColor.grey,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.center
                  )
              ),
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextCustom(
                      text: 'Telefone',
                      size: 14.0,
                      color: PaletteColor.primaryColor,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.center
                  )
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width * 0.85,
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextCustom(
                      text: 'Endereço',
                      size: 14.0,
                      color: PaletteColor.primaryColor,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.center)),
              homeAddress != ""
                  ? Container(
                      width: width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          TextCustomAddress(
                            address:
                            homeAddress,
                            type: 'Casa',
                            width: width * 0.7,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: ()=>deleteAddress('home'),
                            child: Icon(
                              Icons.delete,
                              color: PaletteColor.primaryColor,
                            ),
                          )
                        ],
                      ))
                  : Container(),
              SizedBox(height: 10),
              workAddress != ""
                  ? Container(
                      width: width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          TextCustomAddress(
                            address:
                            workAddress,
                            type: 'Trabalho',
                            width: width * 0.7,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: ()=>deleteAddress('work'),
                            child: Icon(
                              Icons.delete,
                              color: PaletteColor.primaryColor,
                            ),
                          )
                        ],
                      ))
                  : Container(),
              SizedBox(height: 10),
              otherAddress != ""
                  ? Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      TextCustomAddress(
                        address:
                        otherAddress,
                        type: 'Outro',
                        width: width * 0.7,
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: ()=>deleteAddress('other'),
                        child: Icon(
                          Icons.delete,
                          color: PaletteColor.primaryColor,
                        ),
                      )
                    ],
                  ))
                  : Container(),
              SizedBox(height: 10),
              homeAddress == "" || workAddress == "" || otherStreet == ""
              ?TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: PaletteColor.greyLight,
                ),
                onPressed: () => _showDialog(),
                child: TextCustom(
                          size: 14.0,
                          fontWeight: FontWeight.normal,
                          color: PaletteColor.grey,
                          text: 'Adicionar novo endereço',
                          textAlign: TextAlign.center
                        ),
              ): Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonCustom(
                  customWidth: 0.85,
                  onPressed: () {},
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

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  var _controllerAddress = TextEditingController();
  String addressHome = "";
  String addressWork = "";
  String addressOther = "";
  String city = "";
  String village = "";
  String street = "";
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  String apikey = 'AIzaSyBrOfzJKgCwsbPxmc9cSQ6DptcQvluZQFQ';
  var result;
  Timer? _debounce;
  DetailsResult? startPosition;
  late FocusNode? startFocusNode;
  double lat = 0.0;
  double lng = 0.0;
  List titleRadio=['Casa','Trabalho','Outro'];
  int selectedRadioButton=0;
  String selectedText='home';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore db = FirebaseFirestore.instance;

  void autoCompleteSearch(String value) async {
    result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  _verification(){

    if(_controllerAddress.text.isNotEmpty){

      _saveData();

    }else{
      setState(() {
        showSnackBar(context, 'verifique seu endereço', _scaffoldKey);
      });
    }
  }

  _saveData(){
    db.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).update({

      "${selectedText}Address":_controllerAddress.text,
      "${selectedText}Street" :street,
      "${selectedText}Village":village,
      "${selectedText}City"   :city,
      "${selectedText}Lat"    :lat,
      "${selectedText}Lng"    :lng,

    }).then((_)
    => Navigator.pushReplacementNamed(context, '/profile'));
  }

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace(apikey);
    startFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    startFocusNode?.dispose();
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    setSelectedRadio(int value){
      setState(() {
        selectedRadioButton = value;
        if(value == 0){
          selectedText = 'home';
        }else if (value == 1){
          selectedText = 'work';
        }else{
          selectedText = 'other';
        }
        print(selectedText);
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: AlertDialog(
          title: Center(
            child: TextCustom(
              text: 'Adicionar novo endereço',
              size: 13.0,
              color: PaletteColor.grey,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          ),
          titleTextStyle: TextStyle(color: PaletteColor.grey, fontSize: 14),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 120,
                        width: width,
                        child: ListView.builder(
                            itemCount:titleRadio.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 35,
                                width: 140,
                                child: RadioListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  value: index,
                                  groupValue: selectedRadioButton,
                                  activeColor: PaletteColor.primaryColor,
                                  title: Container(
                                      height: 20,
                                      margin: const EdgeInsets.only(top: 15.0),
                                      child: TextCustom(text: titleRadio[index],color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start)
                                  ),
                                  subtitle: Text(''),
                                  onChanged: (value){
                                    setSelectedRadio(int.parse(value.toString()));
                                  },
                                ),
                              );
                            }
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        width: width * 0.9,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: PaletteColor.greyLight,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: PaletteColor.greyLight,
                            )),
                        child: TextFormField(
                          controller: _controllerAddress,
                          focusNode: startFocusNode,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.0,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              autoCompleteSearch(value);
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Rua, Avenida, etc',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: PaletteColor.primaryColor,
                              ),
                              title:
                              Text(predictions[index].description.toString()),
                              onTap: () async {
                                final placeId = predictions[index].placeId;
                                final details =
                                await googlePlace.details.get(placeId!);
                                if (details != null &&
                                    details.result != null &&
                                    mounted) {
                                  setState(() {
                                    startPosition = details.result;
                                    _controllerAddress.text = details.result!.name!;
                                    lat = startPosition!.geometry!.location!.lat!;
                                    lng = startPosition!.geometry!.location!.lng!;
                                    final completeAddress =
                                    startPosition!.adrAddress!;
                                    final splittedStart =
                                    completeAddress.split('>');
                                    street =
                                        splittedStart[1].replaceAll('</span', '');
                                    village =
                                        splittedStart[3].replaceAll('</span', '');
                                    city =
                                        splittedStart[5].replaceAll('</span', '');

                                    print("Street :     " + street.toString());
                                    print("village :  " + village);
                                    print("city :    " + city);
                                    predictions = [];
                                  });
                                }
                              },
                            );
                          }),
                ]);
              }),
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          actionsAlignment: MainAxisAlignment.center,
          titlePadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          actions: [
            Container(
              width: width * 0.3,
              child: ButtonCustom(
                text: 'Salvar',
                colorText: PaletteColor.white,
                colorBorder: PaletteColor.primaryColor,
                onPressed: ()=>_verification(),
                size: 14.0,
                colorButton: PaletteColor.primaryColor,
              ),
            ),
            Container(
              width: width * 0.3,
              child: ButtonCustom(
                text: 'Cancelar',
                colorText: PaletteColor.white,
                colorBorder: PaletteColor.greyInput,
                onPressed: () => Navigator.pop(context),
                size: 14.0,
                colorButton: PaletteColor.greyInput,
              ),
            ),
          ],
        ),
      ),
    );
  }
}