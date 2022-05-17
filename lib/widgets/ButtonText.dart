import '../Utils/export.dart';

class ButtonText extends StatelessWidget {
  final String text;

  ButtonText({
    required this.text
});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: PaletteColor.primaryColor,fontSize: 16)
    );
  }
}
