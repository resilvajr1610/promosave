import '../utils/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _controllerSearch = TextEditingController();
  var _controllerAddress = StreamController<QuerySnapshot>.broadcast();
  var _controllerItems = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _resultsList = [];
  List _allResults = [];

  _data() async {
    Stream<QuerySnapshot> stream = db.collection("user").where('idUser',isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots();
    stream.listen((data) {
      _controllerAddress.add(data);
    });

    var data = await db.collection("items").get();

    setState(() {
      _allResults = data.docs;
    });
    resultSearchList();
    return "complete";
  }
  _search() {
    resultSearchList();
  }
  resultSearchList() {
    var showResults = [];

    if (_controllerSearch.text != "") {
      for (var items in _allResults) {
        var brands = SearchModel.fromSnapshot(items).name.toLowerCase();

        if (brands.contains(_controllerSearch.text.toLowerCase())) {
          showResults.add(items);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  userFirebase ()async{
    String user = await FirebaseAuth.instance.currentUser!.uid;
    if( user==null){
      Navigator.pushReplacementNamed(context, "/register");
    }else{
      _data();
    }
  }

  @override
  void initState() {
    super.initState();
    userFirebase();
    _controllerSearch.addListener(_search);
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: DrawerCustom(),
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: Image.asset('assets/image/logo.png',height: 100,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              InputHome(
                  widget: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          TextCustom(text: 'Cidade - SP',fontWeight: FontWeight.normal,size: 16.0, color: PaletteColor.greyInput,),
                          Spacer(),
                          Icon(Icons.location_on,size: 25,color: PaletteColor.primaryColor,),
                        ],
                      ))),
              InputHome(
                  widget: Container(
                alignment: Alignment.centerLeft,
                width: width*0.8,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controllerSearch,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          color: PaletteColor.grey,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Pesquisar produto',
                            hintStyle: TextStyle(
                              color: PaletteColor.greyInput,
                              fontSize: 16.0,
                            )
                        ),
                      ),
                    ),
                    Icon(Icons.search,size: 25,color: PaletteColor.primaryColor,),
                  ],
                ),
              )),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextCustom(text: 'Tudo',size: 14.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal),
                    TextCustom(text: 'Aberto',size: 14.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal),
                    TextCustom(text: 'Favoritos',size: 14.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal),
                  ],
                ),
              ),
              Container(
                height: height*0.5,
                child: StreamBuilder(
                  stream: _controllerItems.stream,
                  builder: (context, snapshot) {

                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if(_resultsList.length == 0){
                          return Center(
                              child: Text('Produto não encontrado',
                                style: TextStyle(fontSize: 20,color: PaletteColor.primaryColor),)
                          );
                        }else {
                          return ListView.builder(
                              itemCount: _resultsList.length,
                              itemBuilder: (BuildContext context, index) {
                                DocumentSnapshot item = _resultsList[index];

                                String name = item["name"];
                                final photo = item["photo"];
                                final price = item["price"];

                                return CardHome(image: photo,name: name.toUpperCase(),price: price.toStringAsFixed(2).replaceAll(".", ","));
                              }
                          );
                        }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
