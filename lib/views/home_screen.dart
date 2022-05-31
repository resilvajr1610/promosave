import '../Utils/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController _controllerSearch = TextEditingController();
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

  Widget streamAddress() {

    return StreamBuilder<QuerySnapshot>(
      stream:_controllerAddress.stream,
      builder: (context,snapshot){

        if(snapshot.hasError)
          return Text("Erro ao carregar dados!");

        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: Text('Carregando ...'));
          case ConnectionState.active:
          case ConnectionState.done:

            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }else {
              DocumentSnapshot snap = snapshot.data!.docs[0];
              return DropdownMenuItem(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(snap["address"],
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(Icons.location_on,color: PaletteColor.primaryColor),
                    ),
                  ],
                ),
                value: "${snap["address"]}",
              );
            }
        }
      },
    );
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

    return MediaQuery.of(context).size.width<700? Scaffold(
      drawer: Center(
          child: Container(
            alignment: Alignment.center,
            height: double.infinity,
            color: Colors.white,
            child: Text('Em construção',
              style: TextStyle(
                  color: PaletteColor.primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ))
            )
      ),
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: Image.asset('assets/logo.png',height: 100,),
        actions: [
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16.0),
           child: Icon(Icons.tune),
         )
        ],
      ),
      bottomSheet: MenuSheet(),
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Container(
              width: width*0.8,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white60,
                  border: Border.all(
                    color: Colors.black26, //                   <--- border color
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              child:streamAddress(),
            ),
            SizedBox(height: 10),
            InputRegister(
              icons: Icons.search,
              sizeIcon: 0.0,
              width: width*0.8,
              obscure: false,
              controller: _controllerSearch,
              hint: 'Pesquisar produto',
              fonts: 14.0,
              keyboardType: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonText(text: 'Tudo'),
                  ButtonText(text: 'Aberto'),
                  Row(
                    children: [
                      ButtonText(text: 'Favoritos'),
                      Icon(Icons.favorite,color: PaletteColor.primaryColor,)
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32,vertical: 8),
                height: height * 0.65,
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
                                String photo = item["photo"];
                                double price = item["price"];

                                return CadsDelivery(image: photo,price: price.toStringAsFixed(2).replaceAll(".", ","));
                              });
                        }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ):Scaffold(body: Center(child: Text('Em desenvolvimento')));
  }
}
