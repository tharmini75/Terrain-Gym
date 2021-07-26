
import 'dart:async';
import 'package:connection_verify/connection_verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:terrain_gym/admin/schedules/View.dart' as schedule;
import 'package:terrain_gym/admin/dietPlan/View.dart' as dietPlan;
import 'package:terrain_gym/admin/users/GymUser.dart';

import '../../main.dart';
import '../../Common.dart';


class ChangePassword extends StatefulWidget {

  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => new _ChangePasswordState();
}


class _ChangePasswordState extends State<ChangePassword> {
  DateTime currentBackPressTime;
  int popped = 0;
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  ProgressDialog pr;

  Future updatePassword() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    // Create a credential
    EmailAuthCredential credential = EmailAuthProvider.credential(email: user.email, password: _oldPasswordController.text);

    // Re-authenticate
    await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential).then((value) => {
      user.updatePassword(_newPasswordController.text).then((value) => {
        Fluttertoast.showToast(msg: "Password Changed Successfully")
      }).onError((error, stackTrace) => {
        Fluttertoast.showToast(msg: error.toString())
      })
    }).onError((error, stackTrace) => {
      displayError()
    });
    pr.hide().then((value) => {
      setState(() {
        _oldPasswordController.text = "";
        _newPasswordController.text = "";
        _confirmPasswordController.text = "";
      })
    });
  }
  displayError(){
    Fluttertoast.showToast(msg: "Old Password is not matching");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true);
    return  Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset:false,
        extendBodyBehindAppBar: true,
        appBar:  AppBar(
            elevation: 0,
            toolbarHeight: size.height*0.08,
            backgroundColor: primaryColor,
            title: Text("Change Password",
                style: TextStyle(
                    color: primaryColorDark,
                    fontFamily: "ElMessiri",
                    fontSize: size.height*0.035)
            ),
            centerTitle: true,
        ),
        body:SafeArea(
            child:  Container(
                child:SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0,size.height*0.05,0.0,0.0),
                            width: size.width*0.85,
                            child:  Text("Old password",
                                style: TextStyle(
                                    color: accentNewColor,
                                    fontFamily: "GothamMedium",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                          width: size.width * 0.85,
                          child: TextFormField(
                            controller: _oldPasswordController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Old Password",
                              hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.white54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                                //borderSide: const BorderSide(),
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(18.0),
                              fillColor:Colors.white10,
                            ),
                            style: TextStyle(
                                fontSize: size.height*0.023,
                              color: Colors.white,
                              fontFamily: "GothamBook",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Old Password can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0,size.height*0.02,0.0,0.0),
                            width: size.width*0.85,
                            child:  Text("New password",
                                style: TextStyle(
                                    color: accentNewColor,
                                    fontFamily: "GothamMedium",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.85,
                          child: TextFormField(
                            controller: _newPasswordController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "New Password",
                              hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.white54),
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                                //borderSide: const BorderSide(),
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(18.0),
                              fillColor:Colors.white10,
                            ),
                            style: TextStyle(
                                fontSize: size.height*0.023,
                                color: Colors.white,
                              fontFamily: "GothamBook",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'New Password can\'t be empty';
                              }else if(value.length < 6){
                                return 'Password should contain at-least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0,size.height*0.02,0.0,0.0),
                            width: size.width*0.85,
                            child:  Text("Confirm password",
                                style: TextStyle(
                                    color: accentNewColor,
                                    fontFamily: "GothamMedium",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.85,
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.white54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                                //borderSide: const BorderSide(),
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(18.0),
                              fillColor:Colors.white10,
                            ),
                            style: TextStyle(
                                fontSize: size.height*0.023,
                                color: Colors.white,
                              fontFamily: "GothamBook",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Confirm password can\'t be empty';
                              }else if(value != _newPasswordController.text){
                                return 'Password does not match';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(height: size.height*0.03),
                        Container(
                          width: size.width*0.85,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: size.height*0.02, horizontal: 40),
                              color: accentNewColor,
                              onPressed: () async {
                                if (FocusScope
                                    .of(context)
                                    .isFirstFocus) {
                                  FocusScope.of(context).requestFocus(
                                      new FocusNode());
                                }
                                pr.update(message: "Please wait...");
                                if (_formKey.currentState.validate()) {
                                  if (await ConnectionVerify.connectionStatus()) {
                                    await pr.show();
                                    updatePassword();
                                  }else{
                                    Fluttertoast.showToast(msg: "No internet connection");
                                  }

                                }
                              },
                              child: Text(
                                "Change Password",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: "GothamMedium",
                                    fontSize: size.height*0.023),
                              ),
                            ),
                          ),
                        ),
                        Container(height: size.height*0.01 ),

                      ],
                    ),
                  ),
                )
            )
        )
    );

  }
}

