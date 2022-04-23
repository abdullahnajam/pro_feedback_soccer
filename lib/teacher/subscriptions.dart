import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/dialog/add_package.dart';
import 'package:pro_feedback_soccer/model/subscription_model.dart';
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
        child: Column(
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('subscription')
                    .where("teacherId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.size==0) {
                    return Center(
                      child: Column(
                        children: [
                          Image.asset("assets/images/empty.png",width: 150,height: 150,),
                          Text('No Packages Added',)

                        ],
                      ),
                    );
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      SubscriptionModel model=SubscriptionModel.fromMap(data,document.reference.id);
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: InkWell(
                          onTap: (){

                          },
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
                                    child: Text(model.title,style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.w600)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(model.description),
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
                                    child: Text("$currency${model.price}",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w300),),
                                  )
                                ],
                              ),
                            )
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),


          ],
        ),
      )
    );
  }
}
