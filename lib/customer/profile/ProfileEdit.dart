
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


class ProfileEdit extends StatefulWidget {

  ProfileEdit({Key key}) : super(key: key);

  @override
  _ProfileEditState createState() => new _ProfileEditState();
}


class _ProfileEditState extends State<ProfileEdit> {
  DateTime currentBackPressTime;
  int popped = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool checkedValue = false;
  ProgressDialog pr;
  var _firebaseRef = FirebaseDatabase().reference().child('Users');
  Map userData = {};
  final LocalStorage storage = new LocalStorage('terrain');

  Future updateUser() async {
    _firebaseRef.child(FirebaseAuth.instance.currentUser.uid).update({
      "name": _nameController.text,
      "phone": _phoneController.text,
      "weight": double.parse(_weightController.text),
      "height": double.parse(_heightController.text),
      "birthDay": _birthDateController.text,
    });

    Query needsSnapshot = FirebaseDatabase.instance
        .reference()
        .child("Users").child(FirebaseAuth.instance.currentUser.uid);

    await needsSnapshot.once().then((DataSnapshot snapshot) async {
      if (snapshot.value != null) {
        storage.setItem("userData", snapshot.value);
      }
    });
    Fluttertoast.showToast(msg:'Profile Updated Successfully');
    pr.hide();
  }

  @override
  void initState() {
    // TODO: implement initState
    userData = storage.getItem("userData")??{};
    setState(() {
        _nameController.text = userData['name'];
        _heightController.text = userData['height'].toString();
        _weightController.text = userData['weight'].toString();
        _birthDateController.text = userData['birthDay'];
        _emailController.text = userData['email'];
        _phoneController.text = userData['phone'];
    });
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
            title: Text("Profile Edit",
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
                            child:  Text("Full Name",
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
                            controller: _nameController,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              hintText: "Full Name",
                              hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
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
                                return 'Full name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0,size.height*0.02,0.0,0.0),
                            width: size.width*0.85,
                            child:  Text("Email",
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
                            controller: _emailController,
                            cursorColor: primaryColor,
                            enabled: false,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                                //borderSide: const BorderSide(),
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(18.0),
                              fillColor:Colors.black12,
                            ),
                            style: TextStyle(
                                fontSize: size.height*0.023,
                                color: Colors.white70,
                              fontFamily: "GothamBook",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Email can\'t be empty';
                              }else if(!value.isValidEmail()){
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0,size.height*0.02,0.0,0.0),
                            width: size.width*0.85,
                            child:  Text("Contact Number",
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
                            controller: _phoneController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: "Contact Number",
                              hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
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
                                return 'Contact number can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0,size.height*0.02,0.0,0.0),
                            width: size.width*0.85,
                            child:  Text("Birth Date",
                                style: TextStyle(
                                    color: accentNewColor,
                                    fontFamily: "GothamMedium",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.85,
                          child: InkWell(
                            onTap: (){
                              //date picker to get the birth date
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  maxTime: DateTime(new DateTime.now().subtract(Duration(days: 365*10)).year, 12, 31),
                                  theme: DatePickerTheme(
                                      headerColor: accentNewColor,
                                      backgroundColor: primaryColor,
                                      itemStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "ElMessiri",
                                          fontWeight: FontWeight.bold, fontSize: 18),
                                      doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                  onConfirm: (date) {
                                    setState(() {
                                      _birthDateController.text = date.toString().substring(0,10);
                                    });
                                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                            },
                            child: TextFormField(
                              controller: _birthDateController,
                              cursorColor: primaryColor,
                              keyboardType: TextInputType.text,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Birth Date",
                                errorStyle: TextStyle(
                                  color: Theme.of(context).errorColor, // or any other color
                                ),
                                hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
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
                                  return 'Birth Date can\'t be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(width: size.width*0.075),
                            Container(
                              width: size.width*0.425,
                              child: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0.0,size.height*0.02,0.0,0.0),
                                      width: size.width*0.85,
                                      child:  Text("Height",
                                          style: TextStyle(
                                              color: accentNewColor,
                                              fontFamily: "GothamMedium",
                                              fontSize: size.height*0.02)
                                      )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10,right: 10),
                                    width: size.width * 0.85,
                                    child: TextFormField(
                                      controller: _heightController,
                                      cursorColor: primaryColor,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "Height",
                                        hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
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
                                          color: Colors.white, fontFamily: "GothamBook",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Height can\'t be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: size.width*0.425,
                              child: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10.0,size.height*0.01,0.0,0.0),
                                      width: size.width*0.85,
                                      child:  Text("Weight",
                                          style: TextStyle(
                                              color: accentNewColor,
                                              fontFamily: "GothamMedium",
                                              fontSize: size.height*0.02)
                                      )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10,left: 10),
                                    width: size.width * 0.85,
                                    child: TextFormField(
                                      controller: _weightController,
                                      cursorColor: primaryColor,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "Weight",
                                        hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
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
                                          return 'Weigth can\'t be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(width: size.width*0.05),
                          ],
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
                                    updateUser();
                                  }else{
                                    Fluttertoast.showToast(msg: "No internet connection");
                                  }

                                }
                              },
                              child: Text(
                                "Update the User",
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

