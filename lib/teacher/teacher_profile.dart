import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pro_feedback_soccer/dialog/add_bio.dart';
import 'package:pro_feedback_soccer/utils/video_widget.dart';
import 'package:provider/provider.dart';

import '../dialog/show_text_feedback.dart';
import '../dialog/show_video.dart';
import '../model/feedback_model.dart';
import '../provider/UserDataProvider.dart';
import '../utils/constants.dart';
import 'add_feedback.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({Key? key}) : super(key: key);

  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  @override static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
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
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
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
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back,color: primaryColor),
                        ),
                      )
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('My Profile',style: TextStyle(color: primaryColor),),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  provider.userData!.avatar==""?Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image: AssetImage('assets/images/avatar.jpg'),
                            fit: BoxFit.contain,
                          )
                      ),
                    ),
                  ):
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image: NetworkImage(provider.userData!.avatar),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${provider.userData!.firstName} ${provider.userData!.lastName}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("${provider.userData!.email}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("BIO",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                      InkWell(
                        onTap: (){
                          showBioDialog(context);
                        },
                        child: Icon(Icons.edit),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0,top: 5),
                    child: Text(provider.userData!.bio,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                  length: 3,
                  child:Column(
                    children: [
                      TabBar(
                        //controller: _tabController,
                        labelColor:primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorWeight: 0.5,
                        indicatorColor: primaryColor,

                        labelStyle: TextStyle(fontSize: 14),

                        tabs: [
                          Tab(text: 'PENDING',),
                          Tab(text: 'SUBMITTED'),
                          Tab(text: 'REVIEWS'),
                        ],
                      ),

                      Expanded(
                        //height: MediaQuery.of(context).size.height*0.49,

                        child: TabBarView(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('feedback')
                                    .where("teacherId",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                    .where("status",isEqualTo: "Pending").snapshots(),
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
                                          Text('No Pending Videos',)

                                        ],
                                      ),
                                    );
                                  }

                                  return ListView(
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                      FeedbackModel model=FeedbackModel.fromMap(data,document.reference.id);
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 200,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              alignment: Alignment.topRight,
                                              child: VideoWidget(false,model.videoUrl),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: InkWell(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddFeedback(model)));

                                                  },
                                                  child: const CircleAvatar(
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
                                    }).toList(),
                                  );
                                },
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('feedback')
                                    .where("status",isEqualTo: "Posted")
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
                                          Text('No Submitted Feedbacks',)

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
                                                                  child: Text("Video By",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w600)),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(top: 10),
                                                                  child: Text(timeAgoSinceDate(DateTime.fromMillisecondsSinceEpoch(model.datePosted).toString()),style: TextStyle(fontSize:12,color:Colors.black,fontWeight: FontWeight.w300)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          FutureBuilder(
                                                              future: FirebaseFirestore.instance.collection('users').doc(model.studentId).get(),
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
                                                )
                                            )
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('feedback')
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
                                          Text('No Reviews',)

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
                                        child: FutureBuilder(
                                            future: FirebaseFirestore.instance.collection('users').doc(model.studentId).get(),
                                            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Center(
                                                  child: CircularProgressIndicator(),
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

                                                  return ListTile(
                                                    leading: data['avatar']==""?
                                                    Image.asset("assets/images/avatar.jpg")
                                                    :
                                                    Image.network(data['avatar']),
                                                    title: Text("${data['firstName']} ${data['lastName']}"),
                                                    subtitle: RatingBar(
                                                      initialRating: model.rating,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      ignoreGestures: true,
                                                      itemSize: 15,
                                                      ratingWidget: RatingWidget(
                                                        full: Icon(Icons.star,color: primaryColor,),
                                                        half: Icon(Icons.star_half,color: primaryColor),
                                                        empty: Icon(Icons.star_border,color: primaryColor),
                                                      ),
                                                      itemPadding: EdgeInsets.all(0),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                      },
                                                    ),
                                                  );
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
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ]
                        ),
                      )

                    ],

                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
