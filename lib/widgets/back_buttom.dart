import '../utils/export.dart';

class BackButtom extends StatelessWidget {
  final onTap;

  BackButtom({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.topLeft,
          child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: PaletteColor.primaryColor
              ),
              child: Icon(Icons.arrow_back_outlined,color: PaletteColor.white,)),
        ),
      ),
    );
  }
}
