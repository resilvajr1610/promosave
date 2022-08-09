import '../utils/export.dart';

class InputRegister extends StatelessWidget {

  final controller;
  final hint;
  final fonts;
  final keyboardType;
  final obscure;
  final width;
  List<TextInputFormatter>? inputFormatters=[];
  final sizeIcon;
  final icons;

  InputRegister({
    required this.controller,
    required this.hint,
    required this.fonts,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    required this.width,
    this.inputFormatters,
    this.sizeIcon = 0.0,
    this.icons = Icons.clear,
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
        color: PaletteColor.greyLight,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        children: [
          Expanded(
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
                  border: InputBorder.none,
                  hintText: this.hint,
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: this.fonts,
                  )
              ),
            ),
          ),
          Icon(icons,size: sizeIcon),
        ],
      ),
    );
  }
}
