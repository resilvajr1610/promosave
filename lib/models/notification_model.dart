import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Utils/text_const.dart';

sendNotification(String title,String body,String token)async{
  final data = {
    'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
    'id':'1',
    'status':'done',
    'message':title
  };

  try{
    http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
      'Content-Type' : 'application/json',
      'Authorization':'key=${TextConst.KEYTOKEN}'
    },
        body: jsonEncode(<String,dynamic>{
          'notification':<String,dynamic>{
            'title':title,
            'body':body
          },
          'priority':'high',
          'data':data,
          'to':'$token'
        })
    );

    if(response.statusCode == 200){
      print('notif enviada');
    }else{
      print('notif error');
    }

  }catch(e){}
}