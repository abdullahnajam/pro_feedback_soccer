import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_feedback_soccer/dialog/add_package.dart';
import 'package:pro_feedback_soccer/model/subscription_model.dart';
import 'package:pro_feedback_soccer/model/users.dart';
import 'package:pro_feedback_soccer/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:video_player/video_player.dart';

import '../provider/UserDataProvider.dart';
class SubscriptionPackages extends StatefulWidget {
  UserModel teacher;

  SubscriptionPackages(this.teacher);

  @override
  _SubscriptionPackagesState createState() => _SubscriptionPackagesState();
}

class _SubscriptionPackagesState extends State<SubscriptionPackages> {
  String? videoURL;
  File? imagefile;


  File? _video;
  final picker = ImagePicker();
  VideoPlayerController? _controller;


// This funcion will helps you to pick a Video File
  _pickVideo(String teacher,UserModel student) async {
    XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    _video = File(pickedFile!.path);
    uploadVideoToFirebase(context,teacher,student);

  }

  Future uploadVideoToFirebase(BuildContext context,String teacherId,UserModel student) async {
    final ProgressDialog pr = ProgressDialog(context:context);
    pr.show(max: 100, msg: 'Uploading Video');
    firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(_video!);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value)async{
        videoURL=value;
        pr.close();
        await FirebaseFirestore.instance.collection('feedback').add({
          "studentId":FirebaseAuth.instance.currentUser!.uid,
          "teacherId":teacherId,
          "feedbackText":"",
          "feedbackUrl":"",
          "videoUrl":videoURL,
          "type":"",
          "status":"Pending",
          "datePosted":DateTime.now().millisecondsSinceEpoch,
          "feedbackDate":0,
          "review":"no review",
          "rating":0,
          "review_status":"Not Rated",
        });
        await FirebaseFirestore.instance.collection('users').doc(teacherId).get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            pr.close();
            Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
            UserModel user=UserModel.fromMap(data,documentSnapshot.reference.id);
            sendNotification(user.token, "Feedback Added", "Feedback has been added by ${student.firstName} ${student.lastName}", teacherId);

          }
        });

        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Video Submitted For Feedback",
        );
      },
    ).onError((error, stackTrace){
      pr.close();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: error.toString(),
      );
    });
  }


  File? imageFiles;
  String photoUrl="";
  bool _progress = false ;






  late Future<void> _initializeVideoPlayerFuture;
  
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
                    child: Text('Subscription Packages',style: TextStyle(color: primaryColor),),
                  )
                ],
              ),
            ),
            Container(
            margin: EdgeInsets.all(5)
          ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.teacher.avatar==""?Center(
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
                            image: NetworkImage(widget.teacher.avatar),
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
                Text("${widget.teacher.firstName} ${widget.teacher.lastName}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("${widget.teacher.email}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 0),
                  child: Text("Teacher's Bio",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("${widget.teacher.bio}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('subscription')
                    .where("teacherId",isEqualTo: widget.teacher.userId).snapshots(),
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
                          Text('No Packages Added')

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
                            final provider = Provider.of<UserDataProvider>(context, listen: false);
                            _pickVideo(model.teacherId,provider.userData!);
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
