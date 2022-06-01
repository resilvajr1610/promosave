import '../utils/export.dart';

class RatingCustom extends StatelessWidget {
  final rating;

  RatingCustom({required this.rating});

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      starCount: 5,
      color: PaletteColor.star,
      rating: rating,
      borderColor: PaletteColor.star,
      size: 16,
    );
  }
}
