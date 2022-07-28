import '../utils/export.dart';

class ShowDialog extends StatelessWidget {

  final String title;
  final colorTextTitle;
  final colorTextContent;
  final String content;
  final listActions;

  ShowDialog({
    required this.title,
    required this.content,
    required this.listActions,
    this.colorTextTitle = Colors.red,
    this.colorTextContent = Colors.red,
});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
          width: width*0.2,
          height: height*0.05,
        child: TextCustom(text: title,color: colorTextTitle,size: 20.0,fontWeight: FontWeight.bold,)
      ),
      titleTextStyle: TextStyle(color: PaletteColor.primaryColor,fontSize: 20),
      content: Row(
        children: [
          Expanded(
              child:  Container(
                alignment: Alignment.center,
                width: width*0.25,
                height: height*0.1,
                child: TextCustom(
                  textAlign: TextAlign.center,
                  text: content,
                  color: colorTextContent,
                  maxLines: 2,
                ),
              )
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      actions: listActions,
    );
  }
}
