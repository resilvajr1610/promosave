import 'package:flutter/cupertino.dart';

import '../utils/export.dart';

class CardHome extends StatelessWidget {

  final urlPhotoProfile;
  final urlPhotoBanner;
  final startHours;
  final finishHours;
  final name;
  final status;
  final onTap;
  final onTapFavorite;

  CardHome({
    required this.urlPhotoProfile,
    required this.urlPhotoBanner,
    required this.startHours,
    required this.finishHours,
    required this.name,
    required this.status,
    required this.onTap,
    required this.onTapFavorite,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children:[
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              alignment: Alignment.bottomRight,
              height: 130,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: PaletteColor.greyLight,
                image: DecorationImage(
                  image: NetworkImage(urlPhotoBanner!=""?urlPhotoBanner:TextConst.BANNER),
                  alignment: urlPhotoBanner!=""?Alignment.center:Alignment.topCenter,
                  fit: urlPhotoBanner!=""?BoxFit.cover:BoxFit.fitWidth,
                ),
              ),
              child: Container(
                      padding: EdgeInsets.all(6),
                      width: width,
                        decoration: BoxDecoration(
                          color: PaletteColor.white,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft:Radius.circular(10)),
                        ),
                        child:Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: PaletteColor.primaryColor,
                                backgroundImage: NetworkImage(urlPhotoProfile!=""?urlPhotoProfile:TextConst.LOGO),
                              ),
                              SizedBox(width: 8),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.grey, text: name, size: 12.0,textAlign: TextAlign.center),
                                  RatingCustom(rating: 4.0)
                                ],
                              ),
                              Spacer(),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextCustom(fontWeight: FontWeight.normal,color: PaletteColor.grey, text: status, size: 12.0,textAlign: TextAlign.center),
                                  TextCustom(fontWeight: FontWeight.normal,color: PaletteColor.grey, text: startHours!=""?'$startHours - $finishHours':'-', size: 12.0,textAlign: TextAlign.center),
                                ],
                              ),
                            ],
                          )),
              ),
            ),
          Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                  onPressed:onTapFavorite,
                  icon: Icon(Icons.favorite_border,color: PaletteColor.primaryColor,))),
        ],
      ),
    );
  }
}
