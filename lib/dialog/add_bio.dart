import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/model/users.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../provider/UserDataProvider.dart';
import '../utils/constants.dart';

Future<void> showBioDialog(BuildContext context) async {
  var _bio=TextEditingController();
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
                          child: Text("Add Bio",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18)),
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
                    child:Column(
                      children: [
                        TextFormField(
                          maxLines: 5,
                          minLines: 5,
                          controller: _bio,
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
                            hintText: 'Enter Bio',
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: 20,),



                        InkWell(
                          onTap: ()async{
                            final ProgressDialog pr = ProgressDialog(context: context);
                            pr.show(max: 100, msg: 'Please Wait');
                            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                              "bio":_bio.text,


                            }).then((val){
                              final provider = Provider.of<UserDataProvider>(context, listen: false);
                              UserModel user=provider.userData!;
                              user.bio=_bio.text;
                              provider.setUserData(user);

                              pr.close();
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "Bio Successfully Added",
                                  onConfirmBtnTap: (){
                                    Navigator.pop(context);Navigator.pop(context);
                                  }
                              );
                            }).onError((error, stackTrace){
                              pr.close();CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                text: error.toString(),
                              );

                            });


                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(20,10,20,10),
                            child: Text("Add Bio",style: TextStyle(fontSize:18,fontWeight: FontWeight.w400,color: Colors.white),),
                          ),
                        )
                      ],
                    )
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