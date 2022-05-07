import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel{
  String id,teacherId,studentId,feedbackText,feedbackUrl,videoUrl,type,status,review,review_status;
  int datePosted,feedbackDate;
  double rating;

  /*"review":"no review",
          "rating":0,
          "review_status":"Not Rated",*/

  FeedbackModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        studentId = map['studentId'],
        teacherId = map['teacherId'],
        review_status = map['review_status']??"Not Rated",
        rating = double.parse(map['rating'].toString()),
        review = map['review']??"no review",
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