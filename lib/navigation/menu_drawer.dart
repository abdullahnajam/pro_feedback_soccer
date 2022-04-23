import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/login.dart';
import 'package:pro_feedback_soccer/provider/UserDataProvider.dart';
import 'package:pro_feedback_soccer/student/student_profile.dart';
import 'package:pro_feedback_soccer/student/tutorial.dart';
import 'package:pro_feedback_soccer/teacher/teacher_profile.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {




  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/icon.PNG"),
                  fit: BoxFit.contain
                )
              ),
            ),
            Container(height: 10),
            InkWell(onTap: ()async{
              if(provider.userData!.type=="Teacher"){
                Navigator.push(
                    context, MaterialPageRoute(builder: (BuildContext context) => TeacherProfile()));
              }
              else{
                Navigator.push(
                    context, MaterialPageRoute(builder: (BuildContext context) => StudentProfile()));
              }

            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.person, color: Colors.grey, size: 20),
                    Container(width: 20),
                    Expanded(child: Text('My Profile')),
                  ],
                ),
              ),
            ),
            if(provider.userData!.type=="Student")
              Column(
                children: [
                  Container(height: 10),
                  InkWell(onTap: ()async{
                    Navigator.push(
                        context, MaterialPageRoute(builder: (BuildContext context) => Tutorial()));
                  },
                    child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.list_alt, color: Colors.grey, size: 20),
                          Container(width: 20),
                          Expanded(child: Text('Tutorial')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            Container(height: 10),
            InkWell(onTap: ()async{
              await FirebaseAuth.instance.signOut().whenComplete((){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => Login()));
              });
            },
              child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.power_settings_new, color: Colors.grey, size: 20),
                    Container(width: 20),
                    Expanded(child: Text('Logout')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
