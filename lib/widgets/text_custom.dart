import '../utils/export.dart';

class TextCustom extends StatelessWidget {

  final text;
  final size;
  final color;
  final fontWeight;

  TextCustom({required this.text, required this.size,required this.color,required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Nunito',color: color,fontSize: size,fontWeight: fontWeight,)
    );
  }
}
