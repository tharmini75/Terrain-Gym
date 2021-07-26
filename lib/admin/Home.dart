import 'dart:ffi';
import 'dart:io';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:terrain_gym/admin/chat/ChatList.dart';
import 'package:terrain_gym/admin/users/View.dart' as user;
import 'package:terrain_gym/admin/advices/View.dart' as advices;
import 'package:terrain_gym/admin/payments/View.dart' as payments;

import '../main.dart';
import 'Dashboard.dart';


class Home extends StatefulWidget {

  @override
  _HomeState createState() => new _HomeState();
}


class _HomeState extends State<Home> {
  DateTime currentBackPressTime;
  int popped = 0;
  int currentIndex = 0;
  final reference = FirebaseDatabase.instance.reference();


  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if(currentIndex != 0){
      setState(() {
        currentIndex = 0;
      });
      return Future.value(false);
    }else {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Press again to exit");
        return Future.value(false);
      }
      return Future.value(true);
    }
  }

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  List<Widget> _buildScreens() {
    return [
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: onWillPop,
          child: Dashboard(),
        ),
      ),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: onWillPop,
          child: user.View(),
        ),
      ),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: onWillPop,
          child:payments.View(),
        ),
      ),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: onWillPop,
          child:ChatList(),
        ),
      ),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: onWillPop,
          child:advices.View(),
        ),
      ),
    ];
  }
  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            backgroundColor: primaryColorDark,
            resizeToAvoidBottomInset:false,
            extendBodyBehindAppBar: true,
            body: Container(
              height: size.height*0.91,
              child: Navigator(
                key: _navigatorKeys[currentIndex],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => _buildScreens()[currentIndex],
                  );
                },
              ),
            ),
          bottomNavigationBar: Container(
            height: size.height*0.089,
            child: BottomNavigationBar(
                showSelectedLabels: false,   // <-- HERE
                showUnselectedLabels: false, // <-- AND HERE
                type: BottomNavigationBarType.fixed,
                iconSize: size.height*0.03,
                backgroundColor: primaryColor,
                selectedItemColor: primaryColorDark,
                unselectedItemColor: Colors.white38,
                currentIndex: currentIndex,
                elevation: 100,
                onTap: (index){
                  setState(() {
                    currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.home),
                      title: Text('Home')
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.users),
                      title: Text('Users')
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.fileInvoiceDollar),
                      title: Text('Payments')
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.comments),
                      title: Text('Chats')
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.heartbeat),
                      title: Text('Advices')
                  ),
                ]
            ),
          ),
        )
    );

  }
}

