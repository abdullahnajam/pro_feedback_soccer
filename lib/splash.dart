import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/model/users.dart';
import 'package:pro_feedback_soccer/navigation/teacher.dart';
import 'package:pro_feedback_soccer/provider/UserDataProvider.dart';
import 'package:pro_feedback_soccer/register.dart';
import 'package:pro_feedback_soccer/utils/constants.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'navigation/student.dart';
class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with TickerProviderStateMixin{
  AnimationController? animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )
      ..forward()
      ..repeat(reverse: true);
    _loadWidget();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }
  final splashDelay = 4;


  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }
  void navigationPage() async{
    if(FirebaseAuth.instance.currentUser==null){
      print("user not logged in");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));

    }
    else{
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print("user exists");
          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
          UserModel user=UserModel.fromMap(data,documentSnapshot.reference.id);
          print("user ${user.userId} ${user.status}");
          if(user.status=="Pending"){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));

          }
          else if(user.status=="Blocked"){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));

          }

          else if(user.status=="Approved"){
            final provider = Provider.of<UserDataProvider>(context, listen: false);
            provider.setUserData(user);
            print("user type ${user.type}");
            if(user.type=="Teacher")
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TeacherBar()));
            else
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentBar()));

          }
        }
        else{
          print("user donot exists");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
        }

      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child:  Padding(
              padding: EdgeInsets.all(20),
              child: AnimatedBuilder(
                animation: animationController!,
                builder: (context, child) {
                  return Container(
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: CircleBorder(),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0 * animationController!.value),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(50),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: CircleBorder(),
                  ),
                  child: Image.asset("assets/images/icon.PNG",width: 250,height: 250,),
                ),
              ),
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:  Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(""),
            )
          )


        ],
      )
    );
  }
}

