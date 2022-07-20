import '../utils/export.dart';

class TextCustom extends StatelessWidget {

  final text;
  final size;
  final color;
  final fontWeight;
  final textAlign;
  final maxLines;

  TextCustom({
    required this.text,
    required this.size,
    required this.color,
    required this.fontWeight,
    this.maxLines = 1,
    this.textAlign = TextAlign.start
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLines,
        style: TextStyle(fontFamily: 'Nunito',color: color,fontSize: size,fontWeight: fontWeight)
    );
  }
}
