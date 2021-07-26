

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:terrain_gym/Login.dart';

import 'admin/Home.dart' as admin;
import 'customer/Home.dart' as customer;
import 'main.dart';


class Reset extends StatefulWidget {
  @override
  _ResetState createState() => new _ResetState();
}

class _ResetState extends State<Reset> {
  ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future authenticateUser(String email) async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) => {
        pr.hide(),
        Fluttertoast.showToast(msg: "Email sent to the $email"),
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => Login()),
          (route) => false)
      });
    } on FirebaseAuthException catch (e) {
      pr.hide();
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg:'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg:'Wrong password provided for that user.');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true);
    return Scaffold(
      // backgroundColor: primaryColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: size.width * 1,

          height: size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child:  Text(
                    "Reset Password",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: size.height*0.035,
                        color: primaryColor,
                      fontFamily: "GothamMedium"
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0,size.height*0.05,0.0,size.height*0.03),
                  width: size.width*0.3,
                  //Display the logo
                  child: new Image.asset('assets/logo.png'),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10,
                        horizontal: 40),
                    width: size.width * 0.9,
                    child: TextFormField(
                      cursorColor: primaryColor,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email_outlined,
                            color: accentColor),
                        hintStyle: TextStyle(
                            fontSize: size.height * 0.022,
                            color: Colors.black26),
                        border: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)),
                          borderSide: BorderSide.none,
                          //borderSide: const BorderSide(),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.all(18.0),
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: size.height * 0.023,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email can\'t be empty';
                        }
                        return null;
                      },
                    )
                ),
                SizedBox(height: size.height * 0.005),
                Container(
                    width: size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                        color: primaryColor,
                        onPressed: () async {
                          if (FocusScope
                              .of(context)
                              .isFirstFocus) {
                            FocusScope.of(context).requestFocus(
                                new FocusNode());
                          }
                          pr = ProgressDialog(context, type: ProgressDialogType.Normal,
                              isDismissible: false,
                              showLogs: true);
                          pr.update(message: "Please wait...");
                          if (_formKey.currentState.validate()) {
                            await pr.show();
                            authenticateUser(_emailController.text);
                          }
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white,fontSize: size.height*0.02),
                        ),
                      ),
                    )
                ),
                Container(
                  height: size.height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}