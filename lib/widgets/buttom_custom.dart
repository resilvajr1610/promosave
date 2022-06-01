import '../utils/export.dart';

class ButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double size;
  final Color colorButton;
  final Color colorText;
  final Color colorBorder;

  ButtonCustom({
    required this.onPressed,
    required this.text,
    required this.size,
    required this.colorButton,
    required this.colorText,
    required this.colorBorder,
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: this.colorButton,
            minimumSize: Size(width*0.8, height*0.07),
            side: BorderSide(width: 3,color: colorBorder),
          ),
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(fontFamily: 'Nunito',color: colorText,fontSize: 14,fontWeight: FontWeight.bold)
        )
    );
  }
}
