
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
import 'package:terrain_gym/Common.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  AppBar(
          elevation: 0,
          toolbarHeight: size.height*0.08,
          backgroundColor: primaryColor,
          title: Text("Gym Store",
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
                margin: EdgeInsets.only(top:size.height*0.02),
                height: size.height*0.78-3,
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: size.width*0.02,
                  mainAxisSpacing: size.width*0.02,
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.075),
                  // physics: new NeverScrollableScrollPhysics(),
                  children: List.generate(data.length, (index) {
                    double itemHeight = (size.width*0.82/2)*1.34;
                    double itemWidth = size.width*0.82/2;
                    return Container(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: itemHeight*0.7,
                              alignment: Alignment.topCenter,
                              width: itemWidth,
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                        child:ClipRRect(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                          child: Image.network(data[index]['image'],
                                            fit: BoxFit.cover,
                                            height: itemHeight*0.7,
                                            width: itemWidth,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: primaryColor,
                              margin: EdgeInsets.symmetric(horizontal: size.width*0.01),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Stack(
                                children: [
                                  Container(
                                    height: itemHeight*0.3,
                                  ),
                                  Positioned(
                                      bottom: size.width*0.01,
                                      right: size.width*0.02,
                                      child: Text('Rs. ${currencyFormat(data[index]['price'].toString())}',
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: size.height*0.016,
                                              fontFamily: "GothamBook",
                                              fontWeight: FontWeight.bold,
                                              height: 1
                                          )
                                      )
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: size.width*0.01,horizontal: size.width*0.015),
                                    child: Text(data[index]['name'],
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height*0.023,
                                            fontFamily: "ElMessiri",
                                            height: 1.1
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),
                      )
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

