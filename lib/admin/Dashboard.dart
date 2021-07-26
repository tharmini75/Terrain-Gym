import 'dart:ffi';
import 'dart:io';
import 'dart:async';

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

import '../Login.dart';
import '../main.dart';
import 'attendance/View.dart' as attendance;
import 'store/View.dart' as store;


class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => new _DashboardState();
}


class _DashboardState extends State<Dashboard> {
  DateTime currentBackPressTime;
  int popped = 0;
  final secureStorage = new FlutterSecureStorage();
  int attendanceCount = 0, usersCount = 0, itemsCount = 0;
  final DateTime now = new DateTime.now();
  List xAxisLabels = ['-','-','-'];
  List<FlSpot> spotList = [];
  bool data = false;
  final DateFormat formatter = DateFormat('MMM dd');


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
    getData();
    getChartData();
  }

  getData(){
    FirebaseDatabase.instance.reference().child('Users').once().then((DataSnapshot snapshot){
      if(snapshot.value != null) {
        setState(() {
          usersCount = snapshot.value.length;
        });
      }
    });
    FirebaseDatabase.instance.reference().child('Items').once().then((DataSnapshot snapshot){
      if(snapshot.value != null) {
        setState(() {
          itemsCount = snapshot.value.length;
        });
      }
    });
    FirebaseDatabase.instance.reference().child('Attendance').child(now.toString().substring(0,10)).once().then((DataSnapshot snapshot){
      if(snapshot.value != null) {
        setState(() {
          attendanceCount = snapshot.value.length;
        });
      }
    });
  }

  getChartData() async {

    for(int i = 0;i < 30; i++ ){
      DateTime newDate = now.subtract(Duration(days: i));
      await FirebaseDatabase.instance.reference().child('Attendance').child(newDate.toString().substring(0,10)).once().then((DataSnapshot snapshot){
        if(snapshot.value != null) {
          setState(() {
            int count = snapshot.value.length;
            spotList.add(FlSpot((29 - i).toDouble(), count.toDouble()));
          });
        }else{
          setState(() {
            spotList.add(FlSpot((29 - i).toDouble(), 0));
          });
        }
      });
      if(29 - i == 0){
        setState(() {
          xAxisLabels[0] = formatter.format(newDate);
        });
      }else if(29 - i == 15){
        setState(() {
          xAxisLabels[1] = formatter.format(newDate);
        });
      }else if(29 - i == 29){
        setState(() {
          xAxisLabels[2] = formatter.format(newDate);
        });
      }
    }
    print(spotList);
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
                            text: "Do you want to logout",
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
                  // Container(height: size.height*0.025),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width*0.05),
                    height: size.height*0.125,
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getTimeText()}",
                          style: TextStyle(
                              fontSize: size.height*0.025,
                              color: Colors.white70,
                              fontFamily: "ElMessiri",
                            height: 1
                          ),
                        ),
                        Text(
                          "Have a nice day ! ! !",
                          style: TextStyle(
                              fontSize: size.height*0.04,
                              color: Colors.white,
                              fontFamily: "ElMessiri"
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    height: size.height*0.05,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal:size.width*0.05),
                    child: Text(
                      "Attendance",
                      style: TextStyle(
                          fontSize: size.height*0.025,
                          color: Colors.white70,
                          // fontFamily: "ElMessiri",
                          height: 1
                      ),
                    ),
                  ),
                  Container(
                    height: size.height*0.25,
                    margin: EdgeInsets.symmetric(horizontal: size.width*0.05),
                    child: data?Container():LineChart(
                      mainData(),
                    ),
                  ),
                  Container(
                    height: size.height*0.075,
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.symmetric(horizontal:size.width*0.05),
                    child: Text(
                      "Statistics",
                      style: TextStyle(
                          fontSize: size.height*0.04,
                          color: Colors.white70,
                          fontFamily: "ElMessiri",
                        height: 1
                      ),
                    ),
                  ),
                  Container(
                    height: size.height*0.3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(width: size.width*0.067),
                          Container(
                            height: size.height*0.3,
                            width: size.width*0.4,
                            padding: EdgeInsets.symmetric(vertical: size.height*0.02),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return attendance.View();
                                    }));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.peopleArrows,
                                      color: Color(0xFF6FEF8D),
                                      size: size.height*0.05,
                                    ),
                                    Container(height:size.height*0.01),
                                    Container(
                                      child: Text(
                                        "$attendanceCount",
                                        style: TextStyle(
                                            fontSize: size.height*0.045,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "SourceSans",
                                            letterSpacing: 0.5
                                        ),
                                      ),
                                    ),
                                    Container(height:size.height*0.0),
                                    Container(
                                      child: Text(
                                        "Attendance",
                                        style: TextStyle(
                                            fontSize: size.height*0.02,
                                            color: Color(0xFF6FEF8D),
                                            fontFamily: "SourceSans"
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(width: size.width*0.067),
                          Container(
                            height: size.height*0.3,
                            width: size.width*0.4,
                            padding: EdgeInsets.symmetric(vertical: size.height*0.02),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.users,
                                    color: primaryColorDark,
                                    size: size.height*0.05,
                                  ),
                                  Container(height:size.height*0.01),
                                  Container(
                                    child: Text(
                                      "$usersCount",
                                      style: TextStyle(
                                          fontSize: size.height*0.045,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "SourceSans",
                                          letterSpacing: 0.5
                                      ),
                                    ),
                                  ),
                                  Container(height:size.height*0.0),
                                  Container(
                                    child: Text(
                                      "Users",
                                      style: TextStyle(
                                          fontSize: size.height*0.02,
                                          color: primaryColorDark,
                                          fontFamily: "SourceSans"
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(width: size.width*0.067),
                          Container(
                            height: size.height*0.3,
                            width: size.width*0.4,
                            padding: EdgeInsets.symmetric(vertical: size.height*0.02),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return store.View();
                                    }));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.shoppingCart,
                                      color: accentColor,
                                      size: size.height*0.05,
                                    ),
                                    Container(height:size.height*0.01),
                                    Container(
                                      child: Text(
                                        "$itemsCount",
                                        style: TextStyle(
                                            fontSize: size.height*0.045,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "SourceSans",
                                            letterSpacing: 0.5
                                        ),
                                      ),
                                    ),
                                    Container(height:size.height*0.0),
                                    Container(
                                      child: Text(
                                        "Selling Items",
                                        style: TextStyle(
                                            fontSize: size.height*0.02,
                                            color: accentColor,
                                            fontFamily: "SourceSans"
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(width: size.width*0.067),
                        ],
                      ),
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

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white10,
            strokeWidth: 2,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return xAxisLabels[0];
              case 15:
                return xAxisLabels[1];
              case 29:
                return xAxisLabels[2];
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,

        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 30,
      minY: 0,
      maxY: usersCount.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spotList,
          isCurved: true,
          colors: [
            const Color(0xFFF2855E),
          ],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 2),
            colors: gradientColors.map((color) => color).toList(),
          ),
        ),
      ],
    );
  }
}

