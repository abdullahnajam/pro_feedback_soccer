import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/navigation/menu_drawer.dart';
import 'package:pro_feedback_soccer/provider/UserDataProvider.dart';
import 'package:pro_feedback_soccer/teacher/add_feedback.dart';
import 'package:pro_feedback_soccer/utils/video_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../model/feedback_model.dart';
import '../utils/constants.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      drawer: MenuDrawer(),
      key: _drawerKey,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 2,
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
                      InkWell(
                        onTap: (){
                          print("abc");
                          _openDrawer();
                        },
                        child: Icon(Icons.menu,color: Colors.white,),
                      ),
                      SizedBox(width: 10),
                      provider.userData!.avatar==""
                          ?
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/avatar.jpg"),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),

                      )
                          :
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(provider.userData!.avatar),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),

                      ),
                      SizedBox(width: 10),
                      Text("Hi, ${provider.userData!.firstName} ${provider.userData!.lastName}!",style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: StreamBuilder<QuerySnapshot>(
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
          ),

        ],
      ),
    );
  }
}
