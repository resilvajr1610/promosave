import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:promosave/service/app_settings.dart';
import 'package:promosave/service/local_push_notitication.dart';
import 'package:provider/provider.dart';
import '../utils/export.dart';

Future<void> _firebaseMessaginBackgroundHandler(RemoteMessage message)async{

}

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessaginBackgroundHandler);

  String route = '/splash';

  runApp(ChangeNotifierProvider(
    create: (context)=> AppSettings(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: SplashScreen(),
      initialRoute:route,
      onGenerateRoute: Routes.generateRoute,
    ),
  ));
}