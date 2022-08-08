import 'dart:convert';
import 'package:http/http.dart' as http;

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
      'Authorization':'key=AAAAROyEIVo:APA91bHMOkfyv_T5tR37CAerNTNaB9xrZBUjXGeEFlYa5wOwiOW_z0eLk3B_koHO2j09bJxwYvKDUVXI_qZQTn-Ao9ritR7zygynNTn4haL82s6yOjmgj-Z9UHo7NK0Zd9TB8F64nj-h'
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