import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/teacher/add_feedback.dart';

import '../utils/constants.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              ),
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Row(
                    children: [
                    Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/avatar.jpg")
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),

                  ),
                      SizedBox(width: 10),
                      Text("Hi, John Doe!",style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 10,right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search,color: Colors.grey,),
                        SizedBox(width: 10),
                        Text("Search",style: TextStyle(color: Colors.grey),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(

                            image: DecorationImage(
                                image: AssetImage("assets/images/placeholder.png"),
                              fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.topRight,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddFeedback()));

                            },
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor: primaryColor,
                                child:Icon(Icons.assignment_outlined,color: Colors.white,)
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
