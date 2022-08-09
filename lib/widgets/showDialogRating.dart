import '../utils/export.dart';

class ShowDialogRating extends StatelessWidget {

  final onPressedSend;
  final ratingWidget;
  final controller;

  ShowDialogRating({
    required this.onPressedSend,
    required this.ratingWidget,
    required this.controller,
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
        child: TextCustom(text: 'Avalie',color: PaletteColor.grey,size: 20.0,fontWeight: FontWeight.bold,)
      ),
      titleTextStyle: TextStyle(color: PaletteColor.primaryColor,fontSize: 20),
      content: Row(
        children: [
          Expanded(
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ratingWidget,
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height*0.1,
                    child: TextCustom(
                      textAlign: TextAlign.center,
                      text: 'Deixe o seu comentário',
                      color: PaletteColor.grey,
                      maxLines: 1,
                    ),
                  ),
                  InputRegister(
                      controller: controller,
                      hint: 'Opicional',
                      fonts: 14.0,
                      width: width,
                  )
                ],
              )
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      actions: [
        ButtonCustom(
            onPressed: onPressedSend,
            text: 'Enviar',
            size: 12.0,
            colorButton: PaletteColor.primaryColor,
            colorText: PaletteColor.white,
            colorBorder: PaletteColor.primaryColor
        )
      ],
    );
  }
}
