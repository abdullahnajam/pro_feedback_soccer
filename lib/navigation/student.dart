import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/student/feedbacks.dart';
import 'package:pro_feedback_soccer/student/student_homepage.dart';
import 'package:pro_feedback_soccer/teacher/notifications.dart';
import 'package:pro_feedback_soccer/teacher/subscriptions.dart';
import 'package:pro_feedback_soccer/teacher/teacher_homepage.dart';
import 'package:pro_feedback_soccer/utils/constants.dart';

class StudentBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<StudentBar>{

  int _currentIndex = 1;

  List<Widget> _children=[];

  @override
  void initState() {
    super.initState();
    _children = [
      Feedbacks(),
      StudentHomePage(),
      Notifications(),

    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.white,
        index: 1,
        color: primaryColor,
        items: <Widget>[

          Icon(Icons.assignment,color: Colors.white, size: 30),
          Icon(Icons.home,color: Colors.white, size: 30),
          Icon(Icons.notifications,color: Colors.white, size: 30),

        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

        },
      ),
      body: _children[_currentIndex],
    );
  }
}
