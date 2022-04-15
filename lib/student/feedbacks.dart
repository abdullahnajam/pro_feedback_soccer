
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/dialog/add_package.dart';
import 'package:pro_feedback_soccer/utils/constants.dart';
class Feedbacks extends StatefulWidget {
  @override
  _FeedbacksState createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 0.15, color: primaryColor),
                ),
              ),
              height:  AppBar().preferredSize.height,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('Feedbacks',style: TextStyle(color: primaryColor),),
                  )
                ],
              ),
            ),
            Container(
            margin: EdgeInsets.all(5)
          ),
            Container(
              child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: InkWell(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: primaryColor),

                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(height: 100,child: Image.asset("assets/images/placeholder.png",fit: BoxFit.cover,)),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text("Feedback By",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w600)),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text("1 Hour Ago",style: TextStyle(fontSize:12,color:Colors.black,fontWeight: FontWeight.w300)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left:10),
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage("assets/images/avatar.jpg")
                                                ),
                                                borderRadius: BorderRadius.circular(10)
                                            ),

                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left:10),
                                            child: Text("John Doe"),
                                          ),

                                        ],
                                      ),
                                      Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            border: Border.all(color: primaryColor),

                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        margin: EdgeInsets.all(10),
                                        child: Text("View Feedback",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w300),),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: InkWell(
                          child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: primaryColor),

                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(height: 100,child: Image.asset("assets/images/placeholder.png",fit: BoxFit.cover,)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text("Feedback By",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w600)),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text("1 Hour Ago",style: TextStyle(fontSize:12,color:Colors.black,fontWeight: FontWeight.w300)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left:10),
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage("assets/images/avatar.jpg")
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)
                                              ),

                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left:10),
                                              child: Text("John Doe"),
                                            ),

                                          ],
                                        ),
                                        Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: primaryColor,
                                              border: Border.all(color: primaryColor),

                                              borderRadius: BorderRadius.circular(30)
                                          ),
                                          margin: EdgeInsets.all(10),
                                          child: Text("View Feedback",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w300),),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                          )
                      ),
                    ),
                  ]
              )
            ),

          ],
        ),
      )
    );
  }
}
