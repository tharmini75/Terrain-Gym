
import 'package:connection_verify/connection_verify.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../main.dart';

class Add extends StatefulWidget {
  final Map times;
  const Add({
    Key key,
    this.times
  }) : super(key: key);
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  var _firebaseRef;
  final startController = TextEditingController();
  final endController = TextEditingController();
  final startFormKey = GlobalKey<FormState>();
  final endFormKey = GlobalKey<FormState>();
  final DateTime now = new DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    // the credentials are stored on disk for later use
    super.initState();
    _firebaseRef = FirebaseDatabase().reference().child('Users').child(FirebaseAuth.instance.currentUser.uid).child("Attendance");
    if(widget.times.containsKey("start")){
      startController.text = widget.times['start'];
    }
    if(widget.times.containsKey("end")){
      endController.text = widget.times['end'];
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      appBar:  AppBar(
          elevation: 0,
          toolbarHeight: size.height*0.08,
          backgroundColor: primaryColor,
          title: Text("Attendance",
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: size.height*0.03),
                Container(
                  width: size.width*0.9,
                  child: Text("Start Workout",
                      style: TextStyle(
                          color: primaryColorDark,
                          fontFamily: "GothamMedium",
                          fontSize: size.height*0.025)
                  ),
                ),
                Container(height: size.height*0.01),
                Form(
                  key: startFormKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                        width: size.width * 0.44,
                        child: InkWell(
                          onTap: (){
                            //date picker to get the birth date
                            DatePicker.showTimePicker(context,
                                showTitleActions: true,
                                showSecondsColumn: false,
                                theme: DatePickerTheme(
                                    headerColor: primaryColorDark,
                                    backgroundColor: primaryColor,
                                    itemStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "ElMessiri",
                                        fontWeight: FontWeight.bold, fontSize: 18),
                                    doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                onConfirm: (date) {
                                  setState(() {
                                    startController.text = date.toString().substring(11,16);
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                          child: TextFormField(
                            controller: startController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.text,
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "Start Time",
                              hintStyle: TextStyle(fontSize: size.height*0.018,color: Colors.black26),
                              border: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                                //borderSide: const BorderSide(),
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(size.height*0.012),
                              fillColor:textFieldColor,
                              errorStyle: TextStyle(
                                color: Theme.of(context).errorColor, // or any other color
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: size.height*0.018,
                              fontFamily: "GothamBook"
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Start Time can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Container(width: size.width*0.02),
                      Container(
                        width: size.width*0.44,
                        child:  ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: size.height*0.019, horizontal: 40),
                            color: accentNewColor,
                            onPressed: () async {
                              if (FocusScope.of(context).isFirstFocus) {
                                FocusScope.of(context).requestFocus(new FocusNode());
                              }
                              if (startFormKey.currentState.validate()){
                                if (await ConnectionVerify.connectionStatus()) {
                                  _firebaseRef.child(now.toString().substring(0, 10)).update({
                                    "start": startController.text,
                                  });
                                  FirebaseDatabase().reference().child('Attendance').child(
                                      now.toString().substring(0, 10)).child(
                                      FirebaseAuth.instance.currentUser.uid).update({
                                    "start": startController.text,
                                  });
                                  Fluttertoast.showToast(msg: "Attendance marked");
                                  Navigator.of(context).pop();
                                }else{
                                  Fluttertoast.showToast(msg: "No internet connection");
                                }
                              }
                            },
                            child: Text(
                              "Start",
                              style: TextStyle(color: primaryColor,fontSize: size.height*0.021,fontFamily: "GothamMedium"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: size.height*0.03),
                Container(
                  width: size.width*0.9,
                  child: Text("End Workout",
                      style: TextStyle(
                          color: primaryColorDark,
                          fontFamily: "GothamMedium",
                          fontSize: size.height*0.025)
                  ),
                ),
                Container(height: size.height*0.01),
                if(widget.times.containsKey("start"))Form(
                  key: endFormKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                        width: size.width * 0.44,
                        child: InkWell(
                          onTap: (){
                            //date picker to get the birth date
                            DatePicker.showTimePicker(context,
                                showTitleActions: true,
                                showSecondsColumn: false,
                                theme: DatePickerTheme(
                                    headerColor: primaryColorDark,
                                    backgroundColor: primaryColor,
                                    itemStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "ElMessiri",
                                        fontWeight: FontWeight.bold, fontSize: 18),
                                    doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                onConfirm: (date) {
                                  setState(() {
                                    endController.text = date.toString().substring(11,16);
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                          child: TextFormField(
                            controller: endController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.text,
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "End Time",
                              hintStyle: TextStyle(fontSize: size.height*0.018,color: Colors.black26),
                              border: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                                //borderSide: const BorderSide(),
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(size.height*0.012),
                              fillColor:textFieldColor,
                              errorStyle: TextStyle(
                                color: Theme.of(context).errorColor, // or any other color
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: size.height*0.018,
                                fontFamily: "GothamBook"
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'End Time can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Container(width: size.width*0.02),
                      Container(
                        width: size.width*0.44,
                        child:  ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: size.height*0.019, horizontal: 40),
                            color: accentNewColor,
                            onPressed: () async {
                              if (FocusScope.of(context).isFirstFocus) {
                                FocusScope.of(context).requestFocus(new FocusNode());
                              }
                              if (endFormKey.currentState.validate()){
                                if (await ConnectionVerify.connectionStatus()) {
                                  _firebaseRef.child(now.toString().substring(0,10)).update({
                                    "end": endController.text,
                                  });
                                  FirebaseDatabase().reference().child('Attendance').child(now.toString().substring(0,10)).child(FirebaseAuth.instance.currentUser.uid).update({
                                    "end": endController.text,
                                  });
                                  Fluttertoast.showToast(msg: "Attendance marked");
                                  Navigator.of(context).pop();
                                }else{
                                  Fluttertoast.showToast(msg: "No internet connection");
                                }
                              }
                            },
                            child: Text(
                              "End",
                              style: TextStyle(color: primaryColor,fontSize: size.height*0.021,fontFamily: "GothamMedium"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

