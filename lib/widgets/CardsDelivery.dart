import '../Utils/export.dart';

class CadsDelivery extends StatelessWidget {

  final String image;
  final String price;

  CadsDelivery({
    required this.image,
    required this.price,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.symmetric(vertical: 8),
      height: MediaQuery.of(context).size.height*0.2,
      width: MediaQuery.of(context).size.width*0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: NetworkImage(image),
          fit: BoxFit.cover
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
            decoration: BoxDecoration(
              color: PaletteColor.primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'R\$ $price',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20),
            )
        ),
      ),
    );
  }
}
