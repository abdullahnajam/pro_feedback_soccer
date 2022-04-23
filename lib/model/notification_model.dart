import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String id,body,title,userId;
  int date;


  NotificationModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        body = map['body'],
        userId = map['userId'],
        title = map['title'],
        date = map['date'];



  NotificationModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}