import 'dart:ffi';
import 'dart:io';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../main.dart';
import '../../Common.dart';


class Add extends StatefulWidget {

  @override
  _AddState createState() => new _AddState();
}


class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  ProgressDialog pr;
  var _firebaseRef = FirebaseDatabase().reference().child('Users');

  Future addItem() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _phoneController.text
      );

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

      _firebaseRef.child(user.uid).set({
        "id": user.uid,
        "name": _nameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "weight": double.parse(_weightController.text),
        "height": double.parse(_heightController.text),
        "birthDay": _birthDateController.text,
        "registeredOn": date.toString()
      });
      await FirebaseAuth.instance.signOut();
      final secureStorage = new FlutterSecureStorage();
      String email = await secureStorage.read(key: "email");
      String password = await secureStorage.read(key: "password");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      Fluttertoast.showToast(msg: 'User Added Successfully');
      pr.hide();
      setState(() {
        _nameController.text = "";
        _emailController.text = "";
        _phoneController.text = "";
        _birthDateController.text = "";
        _heightController.text = "";
        _weightController.text = "";
      });
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      pr.hide();
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg:'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg:'The account already exists for that email.');
      }
    } catch (e) {
      pr.hide();
      print(e);
      Fluttertoast.showToast(msg:'Something Happened');
    }
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
            title: Text("Add User",
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
                        Container(height: size.height*0.05),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Full Name",
                                style: TextStyle(
                                    color: primaryColorDark,
                                    fontFamily: "SourceSans",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
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
                              contentPadding:EdgeInsets.all(15.0),
                              fillColor:textFieldColor,
                            ),
                            style: TextStyle(
                                fontSize: size.height*0.023
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
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Email",
                                style: TextStyle(
                                    color: primaryColorDark,
                                    fontFamily: "SourceSans",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                              controller: _emailController,
                              cursorColor: primaryColor,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
                                border: OutlineInputBorder(

                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide.none,
                                  //borderSide: const BorderSide(),
                                ),
                                filled: true,
                                contentPadding:EdgeInsets.all(15.0),
                                fillColor:textFieldColor,
                              ),
                              style: TextStyle(
                                  fontSize: size.height*0.023
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
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Contact Number",
                                style: TextStyle(
                                    color: primaryColorDark,
                                    fontFamily: "SourceSans",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
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
                                contentPadding:EdgeInsets.all(15.0),
                                fillColor:textFieldColor,
                                counterText: ""
                              ),
                              maxLength: 10,
                              style: TextStyle(
                                  fontSize: size.height*0.023
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Contact number can\'t be empty';
                                }else if(value.length != 10){
                                  return 'Contact number should consist of 10 characters';
                                }
                                return null;
                              },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Birth Date",
                                style: TextStyle(
                                    color: primaryColorDark,
                                    fontFamily: "SourceSans",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: InkWell(
                            onTap: (){
                              //date picker to get the birth date
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  maxTime: DateTime(new DateTime.now().subtract(Duration(days: 365*10)).year, 12, 31),
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
                                contentPadding:EdgeInsets.all(15.0),
                                fillColor:textFieldColor,
                              ),
                              style: TextStyle(
                                  fontSize: size.height*0.023
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
                            Container(width: size.width*0.05),
                            Container(
                              width: size.width*0.45,
                              child: Column(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                                      width: size.width*0.9,
                                      child:  Text("Height (cm)",
                                          style: TextStyle(
                                              color: primaryColorDark,
                                              fontFamily: "SourceSans",
                                              fontSize: size.height*0.02)
                                      )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10,right: 10),
                                    width: size.width * 0.9,
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
                                        contentPadding:EdgeInsets.all(15.0),
                                        fillColor:textFieldColor,
                                      ),
                                      style: TextStyle(
                                          fontSize: size.height*0.023
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
                              width: size.width*0.45,
                              child: Column(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.fromLTRB(10.0,5,0.0,0.0),
                                      width: size.width*0.9,
                                      child:  Text("Weight (Kg)",
                                          style: TextStyle(
                                              color: primaryColorDark,
                                              fontFamily: "SourceSans",
                                              fontSize: size.height*0.02)
                                      )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10,left: 10),
                                    width: size.width * 0.9,
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
                                        contentPadding:EdgeInsets.all(15.0),
                                        fillColor:textFieldColor,
                                      ),
                                      style: TextStyle(
                                          fontSize: size.height*0.023
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
                          width: size.width*0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: size.height*0.02, horizontal: 40),
                              color: primaryColorDark,
                              onPressed: () async {
                                //close the keyboard before submitting the form
                                if (FocusScope.of(context).isFirstFocus) {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                }
                                pr.update(message: "Please wait...");
                                //validate the add user form
                                if (_formKey.currentState.validate()) {
                                  await pr.show();
                                  addItem();
                                }
                              },
                              child: Text(
                                "Add User",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height*0.023),
                              ),
                            ),
                          ),
                        ),
                        Container(height: size.height*0.01),

                      ],
                    ),
                  ),
                )
            )
        )
    );

  }
}

