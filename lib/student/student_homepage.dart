import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/teacher/add_feedback.dart';

import '../utils/constants.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
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
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width*0.3,
                        decoration: BoxDecoration(

                            image: DecorationImage(
                                image: AssetImage("assets/images/woman.jpg"),
                              fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.topRight,
                      ),
                      SizedBox(width:10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text("Anna Baker",style: TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.w600)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text("Here will the notification description"),
                          ),
                          SizedBox(height:10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.monetization_on_outlined,color: primaryColor,),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Price",style: TextStyle(fontSize: 14,color:Colors.black,fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    child: Text("Starting from \$10.0",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300)),
                                  ),

                                ],
                              )
                            ],
                          ),
                          SizedBox(height:10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.assignment_outlined,color: primaryColor,),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("Feedbacks",style: TextStyle(fontSize: 14,color:Colors.black,fontWeight: FontWeight.w500)),
                                  ),
                                  Container(
                                    child: Text("100 feedbacks",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300)),
                                  ),

                                ],
                              )
                            ],
                          )
                        ],
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
