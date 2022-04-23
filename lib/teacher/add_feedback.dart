import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_feedback_soccer/utils/video_widget.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../model/feedback_model.dart';
import '../model/users.dart';
import '../provider/UserDataProvider.dart';
import '../utils/constants.dart';

class AddFeedback extends StatefulWidget {
  FeedbackModel feedback;

  AddFeedback(this.feedback);

  @override
  _AddFeedbackState createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
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

  String videoURL="";
  File? imagefile;


  File? _video;
  final picker = ImagePicker();
  VideoPlayerController? _controller;


// This funcion will helps you to pick a Video File
  _pickVideo() async {
    XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    _video = File(pickedFile!.path);
    uploadVideoToFirebase(context);
    _initializeVideoPlayerFuture = _controller!.initialize().then((value) {
      setState(() {
      });
    });

  }
  var _feedback=TextEditingController();
  String dropdownValue="Video";
  Future uploadVideoToFirebase(BuildContext context) async {
    final ProgressDialog pr = ProgressDialog(context:context);
    pr.show(max: 100, msg: 'Uploading Video',barrierDismissible: true);
    firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(_video!);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value)async{
      setState(() {
        videoURL=value;
      });

      pr.close();

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
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              child: VideoWidget(false,widget.feedback.videoUrl),
              alignment: Alignment.topRight,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text("Posted By",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(timeAgoSinceDate(DateTime.fromMillisecondsSinceEpoch(widget.feedback.datePosted).toString()),style: TextStyle(color:Colors.black,fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: FirebaseFirestore.instance.collection('users').doc(widget.feedback.studentId).get(),
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
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.only(left: 15,right: 15),
              margin: EdgeInsets.all(10),
              child: DropdownButton<String>(
                value: dropdownValue,
                isExpanded: true,
                elevation: 16,
                style:  TextStyle(color: Colors.grey[700],fontSize: 16),
                underline: Container(

                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Video', 'Text']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            dropdownValue=="Text"?
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: _feedback,
                minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 0.5
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 0.5,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter Feedback',
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            )
            :
            videoURL==""?

            Container(
              width: double.infinity,
              height: 200,
              child: GestureDetector(
                onTap: (){
                  _pickVideo();
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  color: Colors.white,
                  child: DottedBorder(
                      color: primaryColor,
                      strokeWidth: 1,
                      dashPattern: [7],
                      borderType: BorderType.Rect,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/upload.png",color: primaryColor,height: 50,width: 50,fit: BoxFit.cover,),
                            SizedBox(height: 10,),
                            Text("Select Video",style: TextStyle(color: primaryColor,fontWeight: FontWeight.w300),)
                          ],
                        ),
                      )
                  ),
                ),
              ),
            ):InkWell(
              onTap: (){
                _pickVideo();
              },
              child: Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: VideoWidget(false,videoURL)
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: ()async{
                  if(dropdownValue=="Video" && videoURL==""){
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      text: "Please upload a video",
                    );
                  }
                  else if(dropdownValue=="Text" && _feedback.text.trim()==""){
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      text: "Please enter a feedback",
                    );
                  }
                  else{
                    final ProgressDialog pr = ProgressDialog(context:context);
                    pr.show(max: 100, msg: 'Adding Feedback');
                    await FirebaseFirestore.instance.collection('feedback').doc(widget.feedback.id).update({
                      "feedbackText":_feedback.text.trim(),
                      "feedbackUrl":videoURL,
                      "type":dropdownValue,
                      "status":"Posted",
                      "feedbackDate":DateTime.now().millisecondsSinceEpoch,
                    }).then((value)async{
                      pr.close();
                      await FirebaseFirestore.instance.collection('users').doc(widget.feedback.studentId).get().then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          pr.close();
                          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
                          UserModel user=UserModel.fromMap(data,documentSnapshot.reference.id);
                          sendNotification(user.token, "Feedback Added", "Feedback has been added by ${provider.userData!.firstName} ${provider.userData!.lastName}", widget.feedback.studentId);

                        }
                      });
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          text: "Feedback Added",
                          onConfirmBtnTap: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                      );
                    }).onError((error, stackTrace){
                      pr.close();
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: error.toString(),
                      );
                    });
                  }


                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(20,10,20,10),
                  child: Text("Submit Feedback",style: TextStyle(fontSize:18,fontWeight: FontWeight.w400,color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
