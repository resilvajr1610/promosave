import '../utils/export.dart';

class TextCustom extends StatelessWidget {

  final text;
  final size;
  final color;
  final fontWeight;
  final textAlign;

  TextCustom({required this.text, required this.size,required this.color,required this.fontWeight, required this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: TextStyle(fontFamily: 'Nunito',color: color,fontSize: size,fontWeight: fontWeight)
    );
  }
}
