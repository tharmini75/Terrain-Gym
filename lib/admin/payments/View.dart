
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Add.dart';
import '../../main.dart';

class View extends StatefulWidget {
  const View({
    Key key,
  }) : super(key: key);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {

  var _firebaseRef = FirebaseDatabase().reference().child('Users');
  bool data = false;

  @override
  void initState() {
    // TODO: implement initState
    // the credentials are stored on disk for later use
    super.initState();
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
          child: StreamBuilder(
            stream: _firebaseRef.onValue,
            builder: (context, snap) {
              if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                //create a map and store the fetched data
                Map data = snap.data.snapshot.value;
                List item = [];
                data.forEach((index, data) => item.add({"key": index, "name": data['name'],"registeredDate": data['registeredOn']}));
                //create a list view
                return ListView.builder(
                  itemCount: item.length,
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                  itemBuilder: (context, index) {
                    bool status = false;
                    if(index == 0){
                      status = true;
                    }
                    return Container(
                      margin:status?const EdgeInsets.only(top: 20,bottom: 0):const EdgeInsets.only(top:10 ,bottom: 0) ,
                      child: Container(
                          child:Card(
                            color: primaryColor,
                            elevation: 10,
                            child:ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(height: size.height*0.01),
                                  Text(item[index]['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height*0.035,
                                          fontFamily: 'ElMessiri',
                                        height: 1
                                      )
                                    ),
                                  // Container(height: size.height*0.02)
                                ],
                              ),
                              onTap: (){
                                Navigator
                                    .of(context)
                                    .push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => Add(id:item[index]['key'],date:item[index]['registeredDate'])
                                    )
                                );
                              },
                            ),
                          )
                      ),
                    );
                  },
                );
              }
              else
                return Container(
                  color: primaryColor,
                );
            },
          ),
        ),
      ),
    );
  }
}

