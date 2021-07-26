import 'dart:ffi';
import 'dart:io';
import 'dart:async';

import 'package:connection_verify/connection_verify.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:terrain_gym/customer/attendance/View.dart';
import 'package:time_machine/time_machine.dart';

import '../Common.dart';
import '../Login.dart';
import '../main.dart';


class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => new _DashboardState();
}


class _DashboardState extends State<Dashboard> {
  DateTime currentBackPressTime;
  int popped = 0;
  final secureStorage = new FlutterSecureStorage();
  final LocalStorage storage = new LocalStorage('terrain');
  bool manager = false;
  Map user = {};
  int age = 0;
  double feet = 0.0;
  List data = [];
  List<Color> gradientColors = [
    const Color(0x77F2855E),
    const Color(0x00F2855E),
  ];

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Press again to exit");
        return Future.value(false);
      }
      return Future.value(true);

  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    user = storage.getItem("userData")??{};
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(user['birthDay']);
    LocalDate nowDate = LocalDate.today();
    LocalDate firstDate = LocalDate.dateTime(tempDate);
    Period diff = nowDate.periodSince(firstDate);
    age = diff.years;
    feet = double.parse((user['height'] * 0.0328084).toStringAsFixed(1));
    print(feet);
    getData();
  }

  getData() async {

    if (await ConnectionVerify.connectionStatus()){
      Query needsSnapshot = FirebaseDatabase.instance
          .reference()
          .child("Items")
          .orderByKey();

      await needsSnapshot.once().then((DataSnapshot snapshot) {
        print(snapshot.value);
        storage.setItem("store", snapshot.value);
        data.clear();
        if(snapshot.value != null) {
          for (var val in snapshot.value.entries) {
            setState(() {
              data.add(val.value);
            });
          }
        }
      });
    }else {
      Map offlineData = storage.getItem("store")??{};
      for (var val in offlineData.entries) {
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
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            backgroundColor: primaryColor,
            resizeToAvoidBottomInset:false,
            appBar:  AppBar(
                elevation: 0,
                leading: Container(),
                toolbarHeight: size.height*0.08,
                backgroundColor: primaryColor,
                centerTitle: true,
                actions: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right:5.0),
                    child: IconButton(
                      icon:FaIcon(
                        FontAwesomeIcons.signOutAlt,
                        size: size.width*0.07,
                        color: Colors.white70,
                      ),
                      onPressed: () async {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            text: "Do you want to logout?",
                            confirmBtnText: "Yes",
                            onConfirmBtnTap: () async {
                              Navigator.of(context,rootNavigator: true).pop();
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new Login()));

                            },
                            cancelBtnText: "No",
                            confirmBtnColor: Colors.green
                        );

                      },
                    ),
                  )
                ]
            ),
            body: Container(
              height: size.height*0.8,
              color: primaryColor,
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Container(height: size.height*0.5),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width*0.075),
                    height: size.height*0.15,
                    // alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${user['name']}",
                          style: TextStyle(
                              fontSize: size.height*0.025,
                              color: Colors.white70,
                              fontFamily: "ElMessiri",
                              height: 1
                          ),
                        ),
                        Container(height: size.height*0.02),
                        Text(
                          "${getTimeText()} !",
                          style: TextStyle(
                              fontSize: size.height*0.04,
                              color: Colors.white70,
                              fontFamily: "ElMessiri",
                            height: 1
                          ),
                        ),
                        Container(height: size.height*0.02),
                      ],
                    )
                  ),
                  Container(
                    height: size.height*0.65-3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width*0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: size.height*0.3,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                        top: size.height*0.04,
                                        child: Container(
                                          child: Text(
                                            "Your Weight",
                                            style: TextStyle(
                                                fontSize: size.height*0.023,
                                                color: Colors.white,
                                                fontFamily: "GothamMedium"
                                            ),
                                          ),
                                        ),
                                    ),
                                    Container(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${user['weight']}",
                                            style: TextStyle(
                                                fontSize: size.height*0.045,
                                                color: Colors.white,
                                                fontFamily: "GothamMedium",
                                                letterSpacing: 0.5,
                                              height: 1
                                            ),
                                          ),
                                          Text(
                                            "Kg",
                                            style: TextStyle(
                                                fontSize: size.height*0.03,
                                                color: Colors.white,
                                                fontFamily: "GothamBook",
                                                letterSpacing: 0.5,
                                              height: 1
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: size.height*0.03,
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: size.height*0.05,
                                                height: size.height*0.05,
                                                decoration: new BoxDecoration(
                                                  color: Colors.white24,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: FaIcon(
                                                  FontAwesomeIcons.angleDoubleLeft,
                                                  color: primaryColor,
                                                  size: size.height*0.025,
                                                ),
                                              ),
                                              Container(width:size.width*0.06),
                                              Container(
                                                width: size.height*0.05,
                                                height: size.height*0.05,
                                                decoration: new BoxDecoration(
                                                  color: Colors.white24,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: FaIcon(
                                                  FontAwesomeIcons.angleDoubleRight,
                                                  color: primaryColor,
                                                  size: size.height*0.025,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                              Container(height: size.height*0.025),
                              Container(
                                height: size.height*0.3,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                        top: size.height*0.04,
                                        child: Container(
                                          child: Text(
                                            "Your age",
                                            style: TextStyle(
                                                fontSize: size.height*0.023,
                                                color: Colors.white,
                                                fontFamily: "GothamMedium"
                                            ),
                                          ),
                                        ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: size.height*0.01),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${age-1}",
                                            style: TextStyle(
                                                fontSize: size.height*0.04,
                                                color: Colors.white10,
                                                fontFamily: "GothamMedium",
                                                letterSpacing: 0.5,
                                                height: 1
                                            ),
                                          ),
                                          Container(width: size.width*0.015),
                                          Text(
                                            "$age",
                                            style: TextStyle(
                                                fontSize: size.height*0.06,
                                                color: Colors.white,
                                                fontFamily: "GothamMedium",
                                                letterSpacing: 0.5,
                                                height: 1
                                            ),
                                          ),
                                          Container(width: size.width*0.015),
                                          Text(
                                            "${age+1}",
                                            style: TextStyle(
                                                fontSize: size.height*0.04,
                                                color: Colors.white10,
                                                fontFamily: "GothamMedium",
                                                letterSpacing: 0.5,
                                                height: 1
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: size.height*0.03,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: size.width*0.3,
                                              height: size.height*0.05,
                                              decoration: BoxDecoration(
                                                  color: Colors.white10,
                                                  borderRadius: BorderRadius.all(Radius.circular(2000))
                                              ),
                                              alignment: Alignment.center,
                                              child:Text(
                                                "${user['birthDay']}",
                                                style: TextStyle(
                                                    fontSize: size.height*0.018,
                                                    color: Colors.white,
                                                    fontFamily: "GothamMedium",
                                                    letterSpacing: 0.5,
                                                    height: 1
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Container(height: size.height*0.02),
                            ],
                          ),
                        ),
                        Container(
                          width: size.width*0.05,
                        ),
                        Container(
                          width: size.width*0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: size.height*0.5,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: size.height*0.04,
                                      child: Container(
                                        child: Text(
                                          "Your Height",
                                          style: TextStyle(
                                              fontSize: size.height*0.023,
                                              color: Colors.white,
                                              fontFamily: "GothamMedium"
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: size.height*0.03,
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: size.height*0.06,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: size.height*0.06,
                                                      alignment: Alignment.bottomCenter,
                                                      child:RotatedBox(
                                                        quarterTurns: -1,
                                                        child: Row(
                                                          // crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              "${user['height']}",
                                                              style: TextStyle(
                                                                  fontSize: size.height*0.045,
                                                                  color: Colors.white,
                                                                  fontFamily: "GothamMedium",
                                                                  letterSpacing: 0.5,
                                                                  height: 1
                                                              ),
                                                            ),
                                                            Container(width: size.width*0.02),
                                                            Text(
                                                              "cm",
                                                              style: TextStyle(
                                                                  fontSize: size.height*0.035,
                                                                  color: Colors.white,
                                                                  fontFamily: "GothamBook",
                                                                  letterSpacing: 0.5,
                                                                  height: 1
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ),
                                                    ),
                                                    Container(height: size.height*0.04),
                                                    Container(
                                                      width: size.height*0.06,
                                                      height: size.height*0.06,
                                                      decoration: new BoxDecoration(
                                                        color: Colors.white24,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "cm",
                                                        style: TextStyle(
                                                            fontSize: size.height*0.022,
                                                            color:primaryColor,
                                                            fontFamily: "GothamMedium"
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(width:size.width*0.06),
                                              Container(
                                                width: size.height*0.06,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: size.height*0.06,
                                                      padding: EdgeInsets.symmetric(vertical: size.height*0.03),
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius: BorderRadius.all(Radius.circular(2000))
                                                      ),
                                                      alignment: Alignment.center,
                                                      child:Column(
                                                        children: [
                                                          Text(
                                                            "${(feet-0.2).toStringAsFixed(1)}",
                                                            style: TextStyle(
                                                                fontSize: size.height*0.014,
                                                                color:Colors.white38,
                                                                fontFamily: "GothamMedium"
                                                            ),
                                                          ),
                                                          Text(
                                                            ".",
                                                            style: TextStyle(
                                                                fontSize: size.height*0.018,
                                                                color:Colors.white38,
                                                                fontFamily: "GothamMedium"
                                                            ),
                                                          ),
                                                          Container(height: size.height*0.01),
                                                          Text(
                                                            "${(feet-0.1).toStringAsFixed(1)}",
                                                            style: TextStyle(
                                                                fontSize: size.height*0.016,
                                                                color:Colors.white60,
                                                                fontFamily: "GothamMedium"
                                                            ),
                                                          ),
                                                          Text(
                                                            ".",
                                                            style: TextStyle(
                                                                fontSize: size.height*0.018,
                                                                color:Colors.white60,
                                                                fontFamily: "GothamMedium"
                                                            ),
                                                          ),
                                                          Container(height: size.height*0.01),
                                                          Text(
                                                            "$feet",
                                                            style: TextStyle(
                                                                fontSize: size.height*0.018,
                                                                color:Colors.white,
                                                                fontFamily: "GothamMedium"
                                                            ),
                                                          ),
                                                          Text(
                                                            ".",
                                                            style: TextStyle(
                                                                fontSize: size.height*0.018,
                                                                color:Colors.white60,
                                                                fontFamily: "GothamMedium"
                                                            ),
                                                          ),
                                                          Container(height: size.height*0.01),
                                                          Text(
                                                            "${(feet+0.1).toStringAsFixed(1)}",
                                                            style: TextStyle(
                                                                fontSize: size.height*0.016,
                                                                color:Colors.white60,
                                                                fontFamily: "GothamMedium"
                                                            ),
                                                          ),
                                                          Text(
                                                            ".",
                                                            style: TextStyle(
                                                                fontSize: size.height*0.018,
                                                                color:Colors.white38,
                                                                fontFamily: "GothamMedium"
                                                            ),
                                                          ),
                                                          Container(height: size.height*0.01),
                                                          Text(
                                                            "${(feet+0.2).toStringAsFixed(1)}",
                                                            style: TextStyle(
                                                                fontSize: size.height*0.014,
                                                                color:Colors.white38,
                                                                fontFamily: "GothamMedium"
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: size.height*0.01,
                                                      width: size.width*0.02,
                                                      color: primaryColor,
                                                    ),
                                                    Container(
                                                      width: size.height*0.06,
                                                      height: size.height*0.06,
                                                      decoration: new BoxDecoration(
                                                        color: primaryColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "ft",
                                                        style: TextStyle(
                                                            fontSize: size.height*0.023,
                                                            color:Colors.white38,
                                                            fontFamily: "GothamMedium"
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                              Container(height: size.height*0.025),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context) {
                                        return View();
                                      }));
                                },
                                child: Container(
                                  height: size.height*0.1,
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Attendance",
                                              style: TextStyle(
                                                  fontSize: size.height*0.025,
                                                  color: Colors.white,
                                                  fontFamily: "GothamMedium",
                                                  letterSpacing: 0.5,
                                                  height: 1
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: size.height*0.02),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        )
    );
  }

  String getTimeText() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}


