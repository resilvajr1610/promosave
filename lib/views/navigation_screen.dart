import '../utils/export.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int currentIndex=0;
  final screen = [HomeScreen(),MapsScreen(),RequestsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index)=> setState(()=>currentIndex = index),
        backgroundColor: PaletteColor.primaryColor,
        selectedItemColor: PaletteColor.white,
        unselectedItemColor: PaletteColor.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: PaletteColor.primaryColor
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Mapa',
              backgroundColor: PaletteColor.primaryColor
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'Pedidos',
              backgroundColor: PaletteColor.primaryColor
          )
        ],
      ),
    );
  }
}
