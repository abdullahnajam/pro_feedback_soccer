
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/utils/video_widget.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../utils/constants.dart';

Future<void> showFeedbackDialog(BuildContext context,String feedback) async {
  var _feedback=TextEditingController();
  _feedback.text=feedback;
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            insetAnimationDuration: const Duration(seconds: 1),
            insetAnimationCurve: Curves.fastOutSlowIn,
            elevation: 2,

            child: Container(
              height: MediaQuery.of(context).size.height*0.4,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text("Video",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);

                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Icon(Icons.close,color: Colors.black,),
                          ),
                        ),
                      )
                    ],
                  ),

                  Expanded(
                    child:TextFormField(
                      maxLines: 3,
                      minLines: 3,
                      controller: _feedback,
                      readOnly: true,
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
                        hintText: '',
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}