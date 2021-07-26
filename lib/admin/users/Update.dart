
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:terrain_gym/admin/schedules/View.dart' as schedule;
import 'package:terrain_gym/admin/dietPlan/View.dart' as dietPlan;
import 'package:terrain_gym/admin/users/GymUser.dart';

import '../../main.dart';
import '../../Common.dart';


class Update extends StatefulWidget {

  final GymUser user;
  Update({Key key, @required this.user}) : super(key: key);

  @override
  _UpdateState createState() => new _UpdateState();
}


class _UpdateState extends State<Update> {
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


  Future updateUser() async {
    _firebaseRef.child(widget.user.id).update({
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "weight": double.parse(_weightController.text),
      "height": double.parse(_heightController.text),
      "birthDay": _birthDateController.text,
    });
    Fluttertoast.showToast(msg:'User Updated Successfully');
    pr.hide();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
        _nameController.text = widget.user.name;
        _heightController.text = widget.user.height.toString();
        _weightController.text = widget.user.weight.toString();
        _birthDateController.text = widget.user.birthDay;
        _emailController.text = widget.user.email;
        _phoneController.text = widget.user.phone;
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
            title: Text("${widget.user.name.split(" ")[0]}",
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
                        height: size.height*0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap:(){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return schedule.View(id: widget.user.id);
                                    }));
                              },
                              child: FaIcon(
                                FontAwesomeIcons.calendarAlt,
                                size: size.height*0.03,
                                color: accentColor,
                              ),
                            ),
                            Container(width: size.width*0.05),
                            InkWell(
                              onTap:(){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return dietPlan.View(id: widget.user.id);
                                    }));
                              },
                              child: FaIcon(
                                FontAwesomeIcons.hamburger,
                                size: size.height*0.03,
                                color: accentNewColor,
                              ),
                            ),
                            Container(width: size.width*0.05)
                          ],
                        ),
                      ),
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
                          ),
                          style: TextStyle(
                              fontSize: size.height*0.023
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
                                    child:  Text("Height",
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
                                    child:  Text("Weight",
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
                              "Update the User",
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
              ),
            )
        )
    );

  }
}

