import 'package:connection_verify/connection_verify.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import '../../../main.dart';

class View extends StatefulWidget {
  const View({
    Key key,
  }) : super(key: key);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  DatabaseReference _firebaseRef;
  List days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
  List data = [[],[],[],[],[],[],[]];
  final LocalStorage storage = new LocalStorage('terrain');

  @override
  void initState() {
    // TODO: implement initState
    _firebaseRef = FirebaseDatabase().reference().child('Users').child(FirebaseAuth.instance.currentUser.uid).child("Schedule");
    super.initState();
    getData();
  }

  getData() async {
    if (await ConnectionVerify.connectionStatus()){
      Query needsSnapshot = FirebaseDatabase.instance
          .reference()
          .child("Users").child(FirebaseAuth.instance.currentUser.uid).child("Schedule");

      await needsSnapshot.once().then((DataSnapshot snapshot) {
        // storage.setItem("userData", snapshot.value);
        print(snapshot.value);
        if(snapshot.value != null) {
          for (var val in snapshot.value.entries) {
            int index = days.indexOf(val.key);
            Map dayData = val.value??{};
            for (var schedule in dayData.entries) {
              setState(() {
                data[index].add(schedule.value);
              });
            }
          }
        }
      });
      print(data);
    }else {
      Map offlineData = storage.getItem("userData");
      Map scheduleData = offlineData['Schedule']??{};
      print(scheduleData);
      for (var val in scheduleData.entries) {
        int index = days.indexOf(val.key);
        Map dayData = val.value??{};
        for (var schedule in dayData.entries) {
          setState(() {
            data[index].add(schedule.value);
          });
        }
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
          title: Text("Schedule",
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
          width: size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: size.height*0.8,
                  child: DefaultTabController(
                    length: 7,
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: Colors.transparent,
                      appBar:TabBar(
                        isScrollable: false,
                        unselectedLabelColor: Colors.white38,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(fontFamily: "RobotoMedium"),
                        tabs: [
                          Tab(text: "Sun"),
                          Tab(text: "Mon"),
                          Tab(text: "Tue"),
                          Tab(text: "Wed"),
                          Tab(text: "Thu"),
                          Tab(text: "Fri"),
                          Tab(text: "Sat"),
                        ],
                      ),
                      body:TabBarView(
                        children: [
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(height: size.height*0.03),
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                // color: Colors.white,
                                              ),
                                            color: Colors.white
                                          ),
                                        width: size.width*0.45,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Exercise Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: primaryColor,
                                              ),
                                              color: Colors.white
                                          ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Reps",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: primaryColor,
                                              ),
                                              color: Colors.white
                                          ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Sets",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.height*0.65,
                                  child:ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      // physics: new NeverScrollableScrollPhysics(),
                                      itemCount: data[0].length,
                                      itemBuilder: (BuildContext context, int index) =>
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:primaryColor
                                                  ),
                                                  color: Colors.white10
                                                ),
                                                width: size.width*0.45,
                                                padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                child: Text("${data[0][index]['name']}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: size.height*0.018,
                                                        height: 1,
                                                        fontFamily: "GothamBook"
                                                    )
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: primaryColor,
                                                    ),
                                                    color: Colors.white10
                                                ),
                                                width: size.width*0.2,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                child: Text("${data[0][index]['reps']}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: size.height*0.018,
                                                        height: 1,
                                                        fontFamily: "GothamBook"
                                                    )
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: primaryColor,
                                                    ),
                                                    color: Colors.white10
                                                ),
                                                width: size.width*0.2,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                child: Text("${data[0][index]['sets']}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: size.height*0.018,
                                                        height: 1,
                                                        fontFamily: "GothamBook"
                                                    )
                                                ),
                                              ),
                                            ],
                                          )
                                  )
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(height: size.height*0.03),
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              // color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.45,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Exercise Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Reps",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Sets",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: size.height*0.65,
                                    child:ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        // physics: new NeverScrollableScrollPhysics(),
                                        itemCount: data[1].length,
                                        itemBuilder: (BuildContext context, int index) =>
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:primaryColor
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.45,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[1][index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[1][index]['reps']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[1][index]['sets']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                              ],
                                            )
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(height: size.height*0.03),
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              // color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.45,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Exercise Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Reps",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Sets",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: size.height*0.65,
                                    child:ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        // physics: new NeverScrollableScrollPhysics(),
                                        itemCount: data[2].length,
                                        itemBuilder: (BuildContext context, int index) =>
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:primaryColor
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.45,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[2][index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[2][index]['reps']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[2][index]['sets']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                              ],
                                            )
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(height: size.height*0.03),
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              // color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.45,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Exercise Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Reps",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Sets",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: size.height*0.65,
                                    child:ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        // physics: new NeverScrollableScrollPhysics(),
                                        itemCount: data[3].length,
                                        itemBuilder: (BuildContext context, int index) =>
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:primaryColor
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.45,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[3][index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[3][index]['reps']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[3][index]['sets']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                              ],
                                            )
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(height: size.height*0.03),
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              // color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.45,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Exercise Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Reps",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Sets",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: size.height*0.65,
                                    child:ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        // physics: new NeverScrollableScrollPhysics(),
                                        itemCount: data[4].length,
                                        itemBuilder: (BuildContext context, int index) =>
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:primaryColor
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.45,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[4][index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[4][index]['reps']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[4][index]['sets']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                              ],
                                            )
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(height: size.height*0.03),
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              // color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.45,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Exercise Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Reps",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Sets",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: size.height*0.65,
                                    child:ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        // physics: new NeverScrollableScrollPhysics(),
                                        itemCount: data[5].length,
                                        itemBuilder: (BuildContext context, int index) =>
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:primaryColor
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.45,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[5][index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[5][index]['reps']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[5][index]['sets']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                              ],
                                            )
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(height: size.height*0.03),
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              // color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.45,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Exercise Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Reps",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: primaryColor,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                        child: Text("Sets",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1,
                                                fontFamily: "GothamMedium"
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: size.height*0.65,
                                    child:ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        // physics: new NeverScrollableScrollPhysics(),
                                        itemCount: data[6].length,
                                        itemBuilder: (BuildContext context, int index) =>
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:primaryColor
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.45,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[6][index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[6][index]['reps']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primaryColor,
                                                      ),
                                                      color: Colors.white10
                                                  ),
                                                  width: size.width*0.2,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.015),
                                                  child: Text("${data[6][index]['sets']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1,
                                                          fontFamily: "GothamBook"
                                                      )
                                                  ),
                                                ),
                                              ],
                                            )
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

