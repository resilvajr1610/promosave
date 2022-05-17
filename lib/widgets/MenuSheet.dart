import '../Utils/export.dart';
class MenuSheet extends StatelessWidget {
  const MenuSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        color: PaletteColor.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Home',style:TextStyle(color: Colors.white,fontSize: 20)),
            Text('Mapa',style:TextStyle(color: Colors.white,fontSize: 20)),
            Text('Pedido',style:TextStyle(color: Colors.white,fontSize: 20))
          ],
        )
    );
  }
}
