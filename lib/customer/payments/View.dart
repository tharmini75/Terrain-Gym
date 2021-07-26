
import 'package:connection_verify/connection_verify.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import '../../main.dart';

class View extends StatefulWidget {
  const View({
    Key key,
  }) : super(key: key);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  final LocalStorage storage = new LocalStorage('terrain');
  var _firebaseRef = FirebaseDatabase().reference().child('Users');
  List data = [];
  final DateFormat formatter = DateFormat('MMM yyyy');
  Map userData = {};

  @override
  void initState() {
    // TODO: implement initState
    // the credentials are stored on disk for later use
    super.initState();
    getData();
  }

  getData() async {
    final User user = FirebaseAuth.instance.currentUser;
    userData = storage.getItem('userData');
    if (await ConnectionVerify.connectionStatus()){
      Query needsSnapshot = await FirebaseDatabase.instance
          .reference()
          .child("Users").child(user.uid).child("Payments")
          .orderByKey();

      await needsSnapshot.once().then((DataSnapshot snapshot) {
        print(snapshot.value);
        data.clear();
        if(snapshot.value != null) {
          for (var val in snapshot.value.entries) {
            print(val.value);
            setState(() {
              data.add(val.value);
            });
          }
        }
      });
    }else {
      for (var val in userData['Payments'].entries) {
        setState(() {
          data.add(val.value);
        });
      }
      Fluttertoast.showToast(msg: "No internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  AppBar(
          elevation: 0,
          toolbarHeight: size.height*0.08,
          backgroundColor: primaryColor,
          title: Text("Payments",
              style: TextStyle(
                  color: primaryColorDark,
                  fontFamily: "ElMessiri",
                  fontSize: size.height*0.035)
          ),
          centerTitle: true,
      ),
      body:  SafeArea(
        child:Container(
          color: primaryColor,
          width: size.width*1,
          child: Column(
            children: [
              Container(
                height: size.height*0.06,
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          color: Colors.white
                      ),
                      width: size.width*0.5-1,
                      padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                      child: Text("Month",
                          style: TextStyle(
                              color:primaryColor,
                              fontSize: size.height*0.023,
                              height: 1,
                            fontFamily: "GothamMedium"
                          )
                      ),
                    ),
                    Container(
                      width: 1,
                      color: primaryColor,
                      height: size.height*0.028,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          color: Colors.white
                      ),
                      width: size.width*0.4,
                      padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                      child: Text("Paid Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:primaryColor,
                              fontSize: size.height*0.023,
                              height: 1,
                              fontFamily: "GothamMedium"
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // margin: EdgeInsets.all(size.width*0.02),
                height: size.height*0.73,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    // physics: new NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              width: size.width*0.5,
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                              child: Text(
                                  '${formatter.format(new DateFormat("yyyy-MM").parse(data[index]['month']))}',
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: size.height*0.02,
                                      height: 1,
                                      fontFamily: "GothamBook"
                                  )
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              width: size.width*0.4,
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                              child: Text(
                                  '${data[index]['date']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: size.height*0.02,
                                      height: 1,
                                      fontFamily: "GothamBook"
                                  )
                              ),
                            ),
                          ],
                        )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

