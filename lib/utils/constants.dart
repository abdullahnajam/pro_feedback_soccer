import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

const primaryColor=Color(0xff3f448c);
const currency="£";
//const primaryColor=Color(0xff0957df);
const bgColor=Color(0xff8f96fb);
const darkColor=Color(0xff12142f);
const serverToken="AAAACfUoj6w:APA91bG8CBaXLESOehpvpFc6et30knT0ha9OrkKe3UK2FHQ3t5c8MeJdrpx9dRk8JCvMFuSEMO3oC5vDBMfzWQD955lRV63_dR308LHXavwLlkAUKYzuIcKX6_v_LYWKcttuGWjc1iCp";


sendNotification(String userToken,title,body,userId) async{
  String url='https://fcm.googleapis.com/fcm/send';
  Uri myUri = Uri.parse(url);
  await post(
    myUri,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': body,
          'title': title
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': "$userToken",
      },
    ),
  ).whenComplete(()  {
    FirebaseFirestore.instance.collection("notifications").add({

      'date':DateTime.now().millisecondsSinceEpoch,
      'body':body,
      'title':title,
      'userId':userId,
    });

  });
}