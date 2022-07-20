import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promosave/models/shopping_model.dart';
import '../utils/export.dart';

class CarrosselProfessionals extends StatelessWidget {
  final String name;
  final String urlBanner;
  final String urlLogo;
  final double rating;
  final onTap;

  CarrosselProfessionals({
    required this.name,
    required this.urlBanner,
    required this.urlLogo,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          alignment: Alignment.center,
          height: height * 0.25,
          width: width * 0.5,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  alignment: Alignment.bottomRight,
                  height: height*0.09,
                  width: width * 0.5,
                  decoration: BoxDecoration(
                    color: PaletteColor.grey,
                    image: DecorationImage(
                      image: NetworkImage(urlBanner != ""
                          ? urlBanner
                          : TextConst.BANNER),
                      alignment: urlBanner != ""
                          ? Alignment.center
                          : Alignment.topCenter,
                      fit: BoxFit.cover,
                    ),
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: PaletteColor.primaryColor,
                    backgroundImage: urlLogo!=''?NetworkImage(urlLogo):NetworkImage(TextConst.LOGO),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          child: TextCustom(
                            text: name,
                            color: PaletteColor.grey,
                            size: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RatingCustom(rating: rating)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
