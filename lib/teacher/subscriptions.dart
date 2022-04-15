
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/dialog/add_package.dart';
import 'package:pro_feedback_soccer/utils/constants.dart';
class Subscriptions extends StatefulWidget {
  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAddPackageDialog(context);
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
      ),
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
                    child: Text('Subscriptions',style: TextStyle(color: primaryColor),),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10,top: 10),
                                  child: Text("Subscription Title",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.w600)),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text("Here will the subscription description"),
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
                                  child: Text("\$20.00",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w300),),
                                )
                              ],
                            ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10,top: 10),
                                  child: Text("Subscription Title",style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.w600)),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text("Here will the subscription description"),
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
                                  child: Text("\$20.00",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w300),),
                                )
                              ],
                            ),
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
