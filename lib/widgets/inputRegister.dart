import '../Utils/export.dart';

class InputRegister extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final double fonts;
  final TextInputType keyboardType;
  final bool obscure;
  final double width;
  List<TextInputFormatter>? inputFormatters=[];
  Color colorIcon;
  IconData icons;

  InputRegister({
    required this.controller,
    required this.hint,
    required this.fonts,
    required this.keyboardType,
    required this.obscure,
    required this.width,
    this.inputFormatters,
    required this.colorIcon,
    required this.icons,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.topCenter,
      width: this.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white60,
        border: Border.all(
          color: Colors.black26, //                   <--- border color
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: TextFormField(
        obscureText: this.obscure,
        controller: this.controller,
        textAlign: TextAlign.start,
        keyboardType: this.keyboardType,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: Colors.black54,
          fontSize: this.fonts,
        ),
        inputFormatters:this.inputFormatters,
        decoration: InputDecoration(
            icon: Icon(icons,color: this.colorIcon),
            border: InputBorder.none,
            hintText: this.hint,
            hintStyle: TextStyle(
              color: Colors.black54,
              fontSize: this.fonts,
            )
        ),
      ),
    );
  }
}
