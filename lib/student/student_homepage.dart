import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pro_feedback_soccer/model/subscription_model.dart';
import 'package:pro_feedback_soccer/model/users.dart';
import 'package:pro_feedback_soccer/student/packages.dart';
import 'package:pro_feedback_soccer/teacher/add_feedback.dart';
import 'package:provider/provider.dart';

import '../navigation/menu_drawer.dart';
import '../provider/UserDataProvider.dart';
import '../utils/constants.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState!.openDrawer();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(

      drawer: MenuDrawer(),
      key: _drawerKey,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              ),
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          print("abc");
                          _openDrawer();
                        },
                        child: Icon(Icons.menu,color: Colors.white,),
                      ),
                      SizedBox(width: 10),
                    Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(provider.userData!.avatar),
                          fit: BoxFit.cover
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),

                  ),
                      SizedBox(width: 10),
                      Text("Hi, ${provider.userData!.firstName} ${provider.userData!.lastName}!",style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    margin: EdgeInsets.all(10),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(


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
                          hintText: 'Search',
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      noItemsFoundBuilder: (context) {
                        return ListTile(
                          leading: Icon(Icons.error),
                          title: Text("No Teacher Found"),
                        );
                      },
                      suggestionsCallback: (pattern) async {

                        List<UserModel> searchTeachers=[];
                        await FirebaseFirestore.instance
                            .collection('users')
                        .where("type",isEqualTo: "Teacher")
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                            UserModel user=UserModel.fromMap(data, doc.reference.id);
                            if ("${user.firstName} ${user.lastName}".contains(pattern))
                              searchTeachers.add(user);
                          });
                        });

                        return searchTeachers;
                      },
                      itemBuilder: (context, UserModel suggestion) {
                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text("${suggestion.firstName} ${suggestion.lastName}"),
                          subtitle: Text(suggestion.email),
                        );
                      },
                      onSuggestionSelected: (UserModel suggestion) {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SubscriptionPackages(suggestion)));

                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users')
                  .where("type",isEqualTo: "Teacher").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.size==0) {
                  return Center(
                    child: Column(
                      children: [
                        Image.asset("assets/images/empty.png",width: 150,height: 150,),
                        Text('No Teacher Added',)

                      ],
                    ),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    UserModel model=UserModel.fromMap(data,document.reference.id);
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SubscriptionPackages(model)));

                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            model.avatar==""?
                            Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width*0.3,
                              decoration: BoxDecoration(

                                  image: DecorationImage(
                                      image: AssetImage("assets/images/avatar.jpg"),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              alignment: Alignment.topRight,
                            )
                                :
                            Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width*0.3,
                              decoration: BoxDecoration(

                                  image: DecorationImage(
                                      image: NetworkImage(model.avatar),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              alignment: Alignment.topRight,
                            ),
                            SizedBox(width:10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text("${model.firstName} ${model.lastName}",style: TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.w600)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 2),
                                  child: Text("Tap to view packages",style: TextStyle(fontSize: 12,color: Colors.grey),),
                                ),
                                SizedBox(height:10),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10),
                                      child: Image.asset("assets/images/pound.png",height: 20,color: primaryColor,),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text("Price",style: TextStyle(fontSize: 14,color:Colors.black,fontWeight: FontWeight.w500)),
                                        ),
                                        FutureBuilder(
                                            future: getPackageRate(model.userId),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Container(
                                                  child: Text("-",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300)),
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

                                                  return Container(
                                                    child: Text(snapshot.data!.toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300)),
                                                  );
                                                }
                                              }
                                            }
                                        ),


                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height:10),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.assignment_outlined,color: primaryColor,),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text("Feedbacks",style: TextStyle(fontSize: 14,color:Colors.black,fontWeight: FontWeight.w500)),
                                        ),
                                        FutureBuilder(
                                            future: getFeedbackCount(model.userId),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Container(
                                                  child: Text("-",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300)),
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

                                                  return Container(
                                                    child: Text("${snapshot.data!.toString()} Feedbacks",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300)),
                                                  );
                                                }
                                              }
                                            }
                                        ),


                                      ],
                                    )
                                  ],
                                )
                              ],
                            )

                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
  Future<String> getPackageRate(String id)async{
    List<double> prices=[];
    double lowPrice=0;
    await FirebaseFirestore.instance.collection('subscription').where("teacherId",isEqualTo: id).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        SubscriptionModel package=SubscriptionModel.fromMap(data, doc.reference.id);
        prices.add(double.parse(package.price));
        if(lowPrice<double.parse(package.price)) {
          lowPrice=double.parse(package.price);
        }
      });
    });
    if(prices.length>0){
      return "Starting from $currency${lowPrice}";
    }
    else{
      return "No Packages Added";
    }
  }

  Future<int> getFeedbackCount(String id)async{
    int count=0;
    await FirebaseFirestore.instance.collection('feedback')
        .where("teacherId",isEqualTo: id).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        count++;
      });
    });
    return count;
  }
}
