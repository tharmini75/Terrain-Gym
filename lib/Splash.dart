

import 'dart:async';

import 'package:connection_verify/connection_verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:terrain_gym/admin/Home.dart' as admin;
import 'package:terrain_gym/customer/Home.dart' as customer;

import 'Login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  final LocalStorage storage = new LocalStorage('terrain');
  //asynchronous method that delay 2 seconds to call navigationPage function
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    if (user == null) {
      //navigate to login screen
      Navigator.of(context).pop();
      Navigator
          .of(context)
          .push(
          MaterialPageRoute(
              builder: (BuildContext context) => Login()
          )
      );
    } else {
      if(user.email == "admin@gmail.com"){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => admin.Home()),
                (route) => false);
      }else {
        if (await ConnectionVerify.connectionStatus()) {
          Query needsSnapshot = await FirebaseDatabase.instance
              .reference()
              .child("Users").child(user.uid);

          await needsSnapshot.once().then((DataSnapshot snapshot) async {
            if(snapshot.value != null) {
              storage.setItem("userData", snapshot.value);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (c) => customer.Home()),
                      (route) => false);
            }else{
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (c) => Login()),
                      (route) => false);
            }
          });
        }else{
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => customer.Home()),
                  (route) => false);
          Fluttertoast.showToast(msg: "No internet connection");
        }

      }
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return new Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            new Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                  height: size.width*0.7,
                  width: size.width*0.7,
                  //Display the logo
                  child: new Image.asset('assets/logo.png'),
                )
            ),
            Positioned(
                bottom: 10,
                child:Container(
                  width: size.width*1,
                  alignment: Alignment.center,
                  child:  Text(
                    "Powered by Terrain Gym",
                    style: TextStyle(
                        color: Color(0x11000000),
                        fontSize: size.height*0.015
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}