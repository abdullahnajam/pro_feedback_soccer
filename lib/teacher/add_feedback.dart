import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AddFeedback extends StatefulWidget {
  const AddFeedback({Key? key}) : super(key: key);

  @override
  _AddFeedbackState createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/placeholder.png"),
                      fit: BoxFit.cover
                  ),
              ),
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
                    child: Text("1 Hour Ago",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
            ),
            Row(
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
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
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
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(color: Colors.black,),
                Text("OR",style: TextStyle(fontWeight: FontWeight.w300),)
              ],
            ),
            SizedBox(height: 10,),
            Container(
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
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
