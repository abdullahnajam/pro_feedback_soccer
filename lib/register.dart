import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_feedback_soccer/navigation/student.dart';
import 'package:pro_feedback_soccer/navigation/teacher.dart';
import 'package:pro_feedback_soccer/utils/constants.dart';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue="Student";
  var _emailController=TextEditingController();
  var _passwordController=TextEditingController();
  var _firstNameController=TextEditingController();
  var _lastNameController=TextEditingController();
  bool obscure=true;
  String? imgUrl;
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
                Text('Sign Up',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),)
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
                          'SIGN UP TO CONTINUE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sign up to pro feedback soccer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300
                          ),
                        ),


                        Form(
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            children: [
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage("assets/images/avatar.jpg")
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,

                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [

                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        controller: _firstNameController,
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
                                          prefixIcon: Icon(Icons.person,color: Colors.black,size: 22,),
                                          fillColor: Colors.grey[200],
                                          hintText: 'First Name',
                                          // If  you are using latest version of flutter then lable text and hint text shown like this
                                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        controller: _lastNameController,
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
                                          prefixIcon: Icon(Icons.person,color: Colors.black,size: 22,),
                                          fillColor: Colors.grey[200],
                                          hintText: 'Last Name',
                                          // If  you are using latest version of flutter then lable text and hint text shown like this
                                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              buildEmailFormField(),
                              SizedBox(height: 20),
                              buildPasswordFormField(),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(7)
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.perm_contact_calendar_outlined),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15),
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
                                          items: <String>['Teacher', 'Student']
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: () async{
                                  if(_formKey.currentState!.validate()){
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    ).then((value)async{
                                      String? token="";
                                      FirebaseMessaging _fcm=FirebaseMessaging.instance;
                                      token=await _fcm.getToken();
                                      _fcm.subscribeToTopic(dropdownValue);
                                      await FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
                                        "type":dropdownValue,
                                        "firstName":_firstNameController.text,
                                        "lastName":_lastNameController.text,
                                        "email":_emailController.text,
                                        "password":_passwordController.text,
                                        "avatar":imgUrl,
                                        "token":token,
                                      }).then((dbval){
                                        if(dropdownValue=="Teacher")
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TeacherBar()));
                                        else
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentBar()));
                                      }).onError((error, stackTrace){
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: error.toString(),
                                        );
                                      });;
                                    }).onError((error, stackTrace){
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
                                  child: Text('REGISTER',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18),),
                                ),
                              ),
                              SizedBox(height: 30),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Already have an account?',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w300,fontSize: 15),),
                                  SizedBox(height: 3),
                                  GestureDetector(
                                    onTap: () async{
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));



                                    },
                                    child: Container(

                                      child: Text('SIGN IN',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color: primaryColor,fontSize: 17),),
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
        if (value.length<8) {
          return 'Password length should be greater than 8 characters';
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
