import '../utils/export.dart';

class BottomSheetCustom extends StatelessWidget {
  final text;
  final sizeIcon;
  final onTap;

  BottomSheetCustom({
    required this.text,
    required this.sizeIcon,
    required this.onTap,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        color: PaletteColor.primaryColor,
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,color: PaletteColor.white,size: sizeIcon),
            TextCustom(text: text,size: 14.0,color: PaletteColor.white,fontWeight: FontWeight.bold,textAlign:TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
