
import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:images_picker/images_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;
import '../../main.dart';
import 'Advice.dart';


class Update extends StatefulWidget {

  final Advice advice;
  Update({Key key, @required this.advice}) : super(key: key);

  @override
  _UpdateState createState() => new _UpdateState();
}


class _UpdateState extends State<Update> {
  DateTime currentBackPressTime;
  int popped = 0;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  ProgressDialog pr;
  var _firebaseRef = FirebaseDatabase().reference().child('Advices');


  Future updateUser() async {
    _firebaseRef.child(widget.advice.id).update({
      "title": _titleController.text,
      "note": _noteController.text,
    });
    Fluttertoast.showToast(msg:'Advice Updated Successfully');
    pr.hide();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    _titleController.text = widget.advice.title;
    _noteController.text = widget.advice.note;
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
            title: Text("Update Tip",
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
                                if (FocusScope
                                    .of(context)
                                    .isFirstFocus) {
                                  FocusScope.of(context).requestFocus(
                                      new FocusNode());
                                }
                                pr.update(message: "Please wait...");
                                if (_formKey.currentState.validate()) {
                                  await pr.show();
                                  updateUser();
                                }
                              },
                              child: Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.white,
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

