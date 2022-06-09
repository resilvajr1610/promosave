import '../utils/export.dart';

class Routes{
    static Route<dynamic>? generateRoute(RouteSettings settings){
      final args = settings.arguments;

      switch(settings.name){
        case "/home" :
          return MaterialPageRoute(
              builder: (_) => HomeScreen()
          );
        case "/splash" :
          return MaterialPageRoute(
              builder: (_) => SplashScreen()
          );
        case "/initial" :
          return MaterialPageRoute(
              builder: (_) => InitialScreen()
          );
        case "/register" :
          return MaterialPageRoute(
              builder: (_) => RegisterScreen()
          );
        case "/login" :
          return MaterialPageRoute(
              builder: (_) => LoginScreen()
          );
        case "/navigation" :
          return MaterialPageRoute(
              builder: (_) => NavigationScreen()
          );
        case "/profile" :
          return MaterialPageRoute(
              builder: (_) => ProfileScreen()
          );
        case "/shopping" :
          return MaterialPageRoute(
              builder: (_) => ShoppingScreen(args: args as Arguments)
          );
        case "/products" :
          return MaterialPageRoute(
              builder: (_) => ProductsScreen(args: args as Arguments)
          );
        default :
          _erroRota();
      }
    }
    static  Route <dynamic> _erroRota(){
      return MaterialPageRoute(
          builder:(_){
            return Scaffold(
              appBar: AppBar(
                title: Text("Tela em desenvolvimento"),
              ),
              body: Center(
                child: Text("Tela em desenvolvimento"),
              ),
            );
          });
    }
  }