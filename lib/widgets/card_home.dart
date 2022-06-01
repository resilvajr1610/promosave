import 'package:flutter/cupertino.dart';

import '../utils/export.dart';

class CardHome extends StatelessWidget {

  final image;
  final price;
  final name;

  CardHome({
    required this.image,
    required this.price,
    required this.name,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 130,
        width: width*0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: NetworkImage(image),
            fit: BoxFit.cover
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(6),
          width: width,
            decoration: BoxDecoration(
              color: PaletteColor.white,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft:Radius.circular(10)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: PaletteColor.primaryColor,
                  backgroundImage: AssetImage('assets/image/logo.png'),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.grey, text: name, size: 12.0),
                    RatingCustom(rating: 4.0)
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextCustom(fontWeight: FontWeight.normal,color: PaletteColor.grey, text: 'Aberto', size: 12.0),
                    TextCustom(fontWeight: FontWeight.normal,color: PaletteColor.grey, text: '07:00 - 18:00', size: 12.0),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
