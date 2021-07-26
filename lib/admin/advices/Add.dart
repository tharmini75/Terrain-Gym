import 'dart:ffi';
import 'dart:io';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:images_picker/images_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;

import '../../main.dart';


class Add extends StatefulWidget {

  @override
  _AddState createState() => new _AddState();
}


class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  ProgressDialog pr;
  var _firebaseRef = FirebaseDatabase().reference().child('Advices');

  Future addItem() async {
    DateTime now = new DateTime.now();
    try {
      _firebaseRef.push().set({
        "title": _titleController.text,
        "note": _noteController.text,
        "time": now.toString()
      });

      Fluttertoast.showToast(msg: 'Advice Added Successfully');
      pr.hide();
      setState(() {
        _titleController.text = "";
        _noteController.text = "";
      });
      Navigator.of(context).pop();
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
            title: Text("Add Tip",
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
                            child:  Text("Title",
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
                            controller: _titleController,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              hintText: "Title",
                              hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                                //borderSide: const BorderSide(),
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(size.height*0.02),
                              fillColor:textFieldColor,
                            ),
                            style: TextStyle(
                                fontSize: size.height*0.023
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Title can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Note",
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
                              controller: _noteController,
                              cursorColor: primaryColor,
                              keyboardType: TextInputType.text,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Description",
                                hintStyle: TextStyle(fontSize: size.height*0.022,height: 1,color: Colors.black26),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide.none,
                                  //borderSide: const BorderSide(),
                                ),
                                filled: true,
                                contentPadding:EdgeInsets.all(size.height*0.02),
                                fillColor:textFieldColor,
                                counterText: ""
                              ),
                              style: TextStyle(
                                  fontSize: size.height*0.023,
                                  height: 1
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Description number can\'t be empty';
                                }
                                return null;
                              },
                          ),
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
                                "Add Advice",
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

