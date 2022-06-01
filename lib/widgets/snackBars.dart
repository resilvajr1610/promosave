import '../utils/export.dart';

void showSnackBar(BuildContext context, String text,final _scaffoldKey){
  final snackbar = SnackBar(
    backgroundColor: Colors.red,
    content: Row(
      children: [
        Icon(Icons.info_outline,color: Colors.white),
        SizedBox(width: 20),
        Expanded(
          child: Text(text,
            style: TextStyle(fontSize: 16),),
        ),
      ],
    ),
  );

  _scaffoldKey.currentState.showSnackBar(snackbar);
}
