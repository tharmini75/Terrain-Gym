import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:terrain_gym/customer/tips/View.dart' as tips;
import 'package:terrain_gym/customer/store/View.dart' as store;
import 'package:terrain_gym/customer/profile/View.dart' as profile;
import 'package:terrain_gym/customer/chat/View.dart' as chat;

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
  final LocalStorage storage = new LocalStorage('terrain');


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
          child: store.View(),
        ),
      ),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: onWillPop,
          child: tips.View(),
        ),
      ),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: onWillPop,
          child: chat.View(),
        ),
      ),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: onWillPop,
          child: profile.View(),
        ),
      ),
    ];
  }
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    reference
        .child('Users').child(FirebaseAuth.instance.currentUser.uid)
        .onValue.listen((event) {
      var snapshot = event.snapshot.value;
      if(snapshot !=  null) {
        storage.setItem("userData", snapshot);
      }
    });
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
                iconSize: size.height*0.028,
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
                      icon: FaIcon(FontAwesomeIcons.storeAlt),
                      title: Text('Store')
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.heartbeat),
                      title: Text('Advices')
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.comments),
                      title: Text('Payments')
                  ),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.userAlt),
                      title: Text('Profile')
                  ),
                ]
            ),
          ),
        )
    );

  }
}

