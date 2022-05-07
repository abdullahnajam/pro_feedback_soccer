
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/dialog/add_package.dart';
import 'package:pro_feedback_soccer/dialog/add_review.dart';
import 'package:pro_feedback_soccer/dialog/show_text_feedback.dart';
import 'package:pro_feedback_soccer/dialog/show_video.dart';
import 'package:pro_feedback_soccer/model/users.dart';
import 'package:pro_feedback_soccer/utils/constants.dart';

import '../model/feedback_model.dart';
class Feedbacks extends StatefulWidget {
  @override
  _FeedbacksState createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {

  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     
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
                    child: Text('Feedbacks',style: TextStyle(color: primaryColor),),
                  )
                ],
              ),
            ),
            Container(
            margin: EdgeInsets.all(5)
          ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('feedback')
                    .where("studentId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
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
                          Text('No Videos Added',)

                        ],
                      ),
                    );
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      FeedbackModel model=FeedbackModel.fromMap(data,document.reference.id);
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: InkWell(
                            child: Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: primaryColor),

                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: InkWell(
                                                onTap: (){
                                                  showVideoDialog(context, model.videoUrl);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(height: 100,child: Image.asset("assets/images/placeholder.png",fit: BoxFit.cover,)),
                                                ),
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
                                                          child: Text(timeAgoSinceDate(DateTime.fromMillisecondsSinceEpoch(model.datePosted).toString()),style: TextStyle(fontSize:12,color:Colors.black,fontWeight: FontWeight.w300)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  FutureBuilder(
                                                      future: FirebaseFirestore.instance.collection('users').doc(model.teacherId).get(),
                                                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Row(
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
                                                          );
                                                        }
                                                        else {
                                                          if (snapshot.hasError) {
                                                            print("error ${snapshot.error}");
                                                            return const Center(
                                                              child: Text("Something went wrong"),
                                                            );
                                                          }

                                                          else {
                                                            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                                                            return Row(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.only(left:10),
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: NetworkImage(data['avatar']),
                                                                          fit: BoxFit.cover
                                                                      ),
                                                                      borderRadius: BorderRadius.circular(10)
                                                                  ),

                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(left:10),
                                                                  child: Text("${data['firstName']} ${data['lastName']}"),
                                                                ),

                                                              ],
                                                            );
                                                          }
                                                        }
                                                      }
                                                  ),

                                                  InkWell(
                                                    onTap: (){
                                                      if(model.status=="Pending"){
                                                        CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.info,
                                                          text: "Teacher hasn't posted any feedback",
                                                        );
                                                      }
                                                      else{
                                                        if(model.type=="Text"){
                                                          showFeedbackDialog(context, model.feedbackText);
                                                        }
                                                        else{
                                                          showVideoDialog(context, model.feedbackUrl);
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          border: Border.all(color: primaryColor),

                                                          borderRadius: BorderRadius.circular(30)
                                                      ),
                                                      margin: EdgeInsets.all(10),
                                                      child: Text("View Feedback",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w300),),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        model.review_status=="Not Rated" && model.status!="Pending"?
                                        InkWell(
                                          onTap: (){
                                            showReviewDialog(context,model);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.only(

                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              )
                                            ),
                                            alignment: Alignment.center,
                                            child: Text("LEAVE A REVIEW",style: TextStyle(color: Colors.white,fontSize: 15),),
                                          ),
                                        )
                                            :
                                            Container()
                                      ],
                                    )
                                ),

                              ],
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
  Future<UserModel> getUserData(String id)async{
    UserModel? user;
    print("here");
    await FirebaseFirestore.instance.collection('users').doc(id).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        user!=UserModel.fromMap(data,documentSnapshot.reference.id);
        print("uu ${user!.lastName}");

      }

    });
    return user!;

  }
}
