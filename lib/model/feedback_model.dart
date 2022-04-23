import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel{
  String id,teacherId,studentId,feedbackText,feedbackUrl,videoUrl,type,status;
  int datePosted,feedbackDate;


  FeedbackModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        studentId = map['studentId'],
        teacherId = map['teacherId'],
        feedbackText = map['feedbackText'],
        videoUrl = map['videoUrl'],
        type = map['type'],
        status = map['status'],
        feedbackDate = map['feedbackDate'],
        datePosted = map['datePosted'],
        feedbackUrl = map['feedbackUrl'];



  FeedbackModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}