import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              decoration: const BoxDecoration(
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
                          child: const Icon(Icons.arrow_back,color: primaryColor),
                        ),
                      )
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text('Tutorial',style: TextStyle(color: primaryColor),),
                  )
                ],
              ),
            ),
            Container(
              height: 150,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/icon.PNG"),
                      fit: BoxFit.contain
                  )
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text("Step 1 - select a coach from the coaches section",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300),),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text("Step 2 - upload your video for feed back",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300),),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text("Step 3 - complete payment ",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300),),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text("Step 4 - wait for feedback from your coach",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300),),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text("Step 5 - The most important part. Take on board the feedback and go improve your game",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300),),
            ),

          ],
        ),
      ),
    );
  }
}
