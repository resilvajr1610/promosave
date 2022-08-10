import '../utils/export.dart';

void showSnackBar(BuildContext context, String text,final _scaffoldKey){
  final snackbar = SnackBar(
    duration: Duration(seconds: 2),
    backgroundColor: Colors.red,
    content: Container(
      alignment: Alignment.center,
      height: 100,
      child: Row(
        children: [
          Icon(Icons.info_outline,color: Colors.white),
          SizedBox(width: 20),
          Expanded(
            child: Text(text,
              style: TextStyle(fontSize: 16),),
          ),
        ],
      ),
    ),
  );

  _scaffoldKey.currentState.showSnackBar(snackbar);
}
