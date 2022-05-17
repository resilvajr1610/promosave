import 'package:flutter/material.dart';
import 'package:promosave/Utils/export.dart';

void main(){

  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  String route = '/register';

  if(FirebaseAuth.instance.currentUser != null){
    route = '/home';
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute:route,
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}