import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel{
  String id,teacherId,title,description;
  String price;


  SubscriptionModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        price = map['price'],
        teacherId = map['teacherId'],
        title = map['title'],
        description = map['description'];



  SubscriptionModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}