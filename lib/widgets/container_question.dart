import '../Utils/colors.dart';
import '../Utils/export.dart';

class ContainerQuestion extends StatelessWidget {

  final question;
  final answer;
  final onTap;
  final showAnswer;

  ContainerQuestion({
    required this.question,
    required this.answer,
    required this.onTap,
    required this.showAnswer,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: width*0.8,
                child: TextCustom(
                    text: question,
                    size: 15.0,
                    color: PaletteColor.grey,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start
                ),
              ),
            ),
            Icon(showAnswer==true? Icons.arrow_drop_down:Icons.arrow_right,color: PaletteColor.greyInput,)
          ],
        ),
        showAnswer==true?Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          width: width,
          child: TextCustom(
              text: answer,
              size: 14.0,
              color: PaletteColor.grey,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.start
          ),
        ):Container(),
        Divider(thickness: 2,)
      ],
    );
  }
}
