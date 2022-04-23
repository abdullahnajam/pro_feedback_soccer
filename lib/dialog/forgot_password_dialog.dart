
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

Future<void> showForgotPasswordDialog(BuildContext context) async {
  var _emailController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
              height: MediaQuery.of(context).size.height*0.28,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text("Forgot Password",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: ()async{
                              await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim()).then((value)async{
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "An email has been send for password reset",
                                  onConfirmBtnTap: (){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                );

                              }).onError((error, stackTrace){
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  text: error.toString(),
                                );
                              });


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
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(height: 10,),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
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
                              hintText: 'Enter Email',
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),

                          SizedBox(height: 20,),



                          InkWell(
                            onTap: (){
                              if (_formKey.currentState!.validate()) {
                               
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: darkColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(20,10,20,10),
                              child: Text("Submit",style: TextStyle(fontSize:18,fontWeight: FontWeight.w400,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}