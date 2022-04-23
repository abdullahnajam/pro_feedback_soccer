import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/model/users.dart';
import 'package:pro_feedback_soccer/navigation/student.dart';
import 'package:pro_feedback_soccer/navigation/teacher.dart';
import 'package:pro_feedback_soccer/provider/UserDataProvider.dart';
import 'package:pro_feedback_soccer/register.dart';
import 'package:pro_feedback_soccer/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _emailController=TextEditingController();
  var _passwordController=TextEditingController();
  bool obscure=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,

      body: Stack(
        children: [
          Container(
            child: Row(
              children: [

                SizedBox(width: 10,),
                Text('Sign In',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),)
              ],
            ),
            margin: EdgeInsets.only(top: 50,left: 20,right: 20),
          ),
          Container(

            margin: EdgeInsets.only(top: 100),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)
                )
            ),
            padding:
            EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'WELCOME BACK!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sign in with your email and password to continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              buildEmailFormField(),
                              SizedBox(height: 20),
                              buildPasswordFormField(),
                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async{

                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));



                                    },
                                    child: Container(
                                      alignment: Alignment.center,

                                      child: Text('Forgot Password?',textAlign: TextAlign.center,style: TextStyle(color: primaryColor,fontSize: 15),),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: () async{

                                  if(_formKey.currentState!.validate()){
                                    final ProgressDialog pr = ProgressDialog(context: context);
                                    pr.show(max: 100, msg: 'Logging In');
                                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text
                                    ).then((value)async{
                                      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((DocumentSnapshot documentSnapshot) async{
                                        if (documentSnapshot.exists) {
                                          pr.close();
                                          Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
                                          UserModel user=UserModel.fromMap(data,documentSnapshot.reference.id);
                                          if(user.status=="Pending"){
                                            FirebaseAuth.instance.signOut();
                                            CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.info,
                                              text: "Your account is pending for approval from admin",
                                            );
                                          }
                                          else if(user.status=="Blocked"){
                                            FirebaseAuth.instance.signOut();
                                            CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Your account is blocked by admin",
                                            );
                                          }

                                          else if(user.status=="Approved"){
                                            String? token="";
                                            FirebaseMessaging _fcm=FirebaseMessaging.instance;
                                            token=await _fcm.getToken();
                                            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                              "token":token,
                                            });
                                            final provider = Provider.of<UserDataProvider>(context, listen: false);
                                            provider.setUserData(user);
                                            print("user type ${user.type}");
                                            if(user.type=="Teacher")
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TeacherBar()));
                                            else
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentBar()));

                                          }
                                        }
                                        else{
                                          pr.close();
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "No User Data",
                                          );
                                        }
                                      });
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
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width*0.9,

                                  height: 50,
                                  child: Text('LOGIN',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18),),
                                ),
                              ),
                              SizedBox(height: 30),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Don\'t have an account?',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w300,fontSize: 15),),
                                  SizedBox(height: 3),
                                  GestureDetector(
                                    onTap: () async{
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Register()));



                                    },
                                    child: Container(

                                      child: Text('SIGN UP',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color: primaryColor,fontSize: 17),),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            height: MediaQuery.of(context).size.height*0.85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/icon.PNG",height: 20,),
                               
                              ],
                            )
                        )
                    )
                  ],
                )
            ),
          )
        ],
      ),

    );
  }
  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        return null;
      },
      controller: _passwordController,
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
        prefixIcon: Icon(Icons.lock_outline,color: Colors.black,size: 22,),
        fillColor: Colors.grey[200],
        hintText: 'Enter Password',
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: _emailController,
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
        prefixIcon: Icon(Icons.alternate_email,color: Colors.black,size: 22,),
        fillColor: Colors.grey[200],
        hintText: 'Enter Email',
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
