
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
  List data = [];

  @override
  void initState() {
    // TODO: implement initState
    // the credentials are stored on disk for later use
    super.initState();
    getData();
  }

  getData() async {

    if (await ConnectionVerify.connectionStatus()){
      Query needsSnapshot = FirebaseDatabase.instance
          .reference()
          .child("Advices")
          .orderByChild("time");

      await needsSnapshot.once().then((DataSnapshot snapshot) {
        print(snapshot.value);
        storage.setItem("tips", snapshot.value);
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
      Map offlineData = storage.getItem("tips")??{};
      for (var val in offlineData.entries) {
        setState(() {
          data.add(val.value);
        });
      }
      Fluttertoast.showToast(msg: "No internet connection");
    }
    data.sort((a, b) {
      return b["time"].compareTo(a["time"]);
    });
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
          title: Text("Health Tips",
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
                // margin: EdgeInsets.all(size.width*0.02),
                height: size.height*0.8-3,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    // physics: new NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) =>
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: size.width*0.05,vertical: size.height*0.01),
                        child:Container(
                          decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          padding: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.height*0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color: Colors.white54,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Container(
                                        height: size.height*0.06,
                                        width: size.height*0.06,
                                        alignment: Alignment.center,
                                        // padding: EdgeInsets.all(size.height*0.05),
                                        child: Image.asset(
                                          'assets/logo.png',
                                          height: size.height*0.05,
                                          width: size.height*0.05,
                                        )
                                    ) ,
                                  ),
                                  Container(
                                    width: size.width*0.02,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: size.height*0.002),
                                    width: size.width*0.6,
                                    child: Text(data[index]['title'],
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height*0.025,
                                            fontFamily: "GothamMedium",
                                            height: 1.2
                                        )
                                    ),
                                  )
                                ],
                              ),
                              Container(height: size.height*0.01),
                              Container(
                                // alignment: Alignment.centerRight,
                                child: Text(data[index]['note'],
                                    // textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize:  size.height*0.016,
                                      height: 1,
                                      fontFamily: 'GothamBook',
                                    )
                                ),
                              ),
                              Container(
                                // alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(data[index]['time'].toString().substring(0,10),
                                          // textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:  size.height*0.014,
                                            height: 1,
                                            fontFamily: 'GothamBook',
                                          )
                                      ),
                                      Container(width: size.width*0.01),
                                      Icon(
                                        Icons.adjust,
                                        size: size.height*0.004,
                                        color: Colors.white,
                                      ),
                                      Container(width: size.width*0.01),
                                      Text(data[index]['time'].toString().substring(11,16),
                                          // textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:  size.height*0.014,
                                            height: 1,
                                            fontFamily: 'GothamBook',
                                          )
                                      ),
                                    ],
                                  )
                              ),
                              // Container(height: size.height*0.01)
                            ],
                          ),
                        ),
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

