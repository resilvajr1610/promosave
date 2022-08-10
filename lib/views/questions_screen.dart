import '../utils/export.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controllerSearch = TextEditingController();
  List _allResults = [];
  List _resultsList = [];
  List<QuestionModel> listQuestionModel=[];

  dataFirebase()async{
    var data = await db.collection("questions").where('type', isEqualTo: TextConst.CLIENT).get();
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
        var brands = SearchQuestionModel.fromSnapshot(items).question.toLowerCase();

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

  @override
  void initState() {
    super.initState();
    print(FirebaseAuth.instance.currentUser!.uid);
    _controllerSearch.addListener(_search);
    dataFirebase();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PaletteColor.white,
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!=null?FirebaseAuth.instance.currentUser!.displayName!:'',
        photo: FirebaseAuth.instance.currentUser!.photoURL,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: TextCustom(
          text: 'Perguntas frequentes',
          size: 24.0,
          color: PaletteColor.white,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: ()async{
          await launch('https://wa.me/+554199952037?text=Dúvidas PromoSave');
        },
        child: Container(
          color: PaletteColor.white,
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.whatsapp,color: PaletteColor.green,size: 40,),
              SizedBox(width:10),
              Container(
                width: width*0.75,
                child: TextCustom(
                    text: 'Dúvidas? Chamar no WhatsApp',
                    size: 16.0,
                    color: PaletteColor.grey,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.start
                ),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InputHome(
                  widget: Container(
                    alignment: Alignment.centerLeft,
                    width: width * 0.8,
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
                                hintText: 'Pesquisar',
                                hintStyle: TextStyle(
                                  color: PaletteColor.greyInput,
                                  fontSize: 16.0,
                                )),
                          ),
                        ),
                        Icon(
                          Icons.search,
                          size: 25,
                          color: PaletteColor.primaryColor,
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 20),
              Container(
                height: height*0.6,
                child: ListView.builder(
                  itemCount: _resultsList.length,
                  itemBuilder:(context,index) {

                    DocumentSnapshot item = _resultsList[index];

                    if(_resultsList.length == 0){
                      return Center(
                          child: Text('Nenhuma pergunta encontrada dessa categoria',
                            style: TextStyle(fontSize: 16,color: PaletteColor.primaryColor),)
                      );
                    }else{
                      listQuestionModel.add(
                          QuestionModel(
                              answer: item['answer'],
                              question: item['question'],
                              showQuestion: false
                          )
                      );

                      return ContainerQuestion(
                        showAnswer: listQuestionModel[index].showQuestion,
                        question:  listQuestionModel[index].question,
                        answer: listQuestionModel[index].answer,
                        onTap: () {
                          setState(() {
                            listQuestionModel[index].showQuestion?listQuestionModel[index].showQuestion=false:listQuestionModel[index].showQuestion=true;
                          });
                        },
                      );
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
