import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String userId,firstName,lastName,email,password,avatar,status,token,type;
  double rating;
  String bio;


  UserModel.fromMap(Map<String,dynamic> map,String key)
      : userId=key,
        firstName = map['firstName'],
        lastName = map['lastName'],
        email = map['email'],
        rating = map['rating']??0,
        bio = map['bio']??"no bio",
        password = map['password'],
        avatar = map['avatar'],
        type = map['type'],
        status = map['status'],
        token = map['token'];



  UserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}