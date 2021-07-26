

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:terrain_gym/Reset.dart';

import 'admin/Home.dart' as admin;
import 'customer/Home.dart' as customer;
import 'main.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  DateTime currentBackPressTime;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  ProgressDialog pr;
  final secureStorage = new FlutterSecureStorage();
  final LocalStorage storage = new LocalStorage('terrain');


  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }


  Future authenticateUser(String email, String password) async {

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;

      print(user.email);
      if (user == null) {
          print('User is currently signed out!');
        } else {
          //User is signed in
          if(email == "admin@gmail.com"){

            await secureStorage.write(key: 'email', value: user.email.toString());
            await secureStorage.write(key: 'password', value: _passwordController.text.toString());

            Fluttertoast.showToast(msg:'Login Successful');
            pr.hide();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (c) => admin.Home()),
                      (route) => false);
            });

          }else{
            Query needsSnapshot = await FirebaseDatabase.instance
                .reference()
                .child("Users").child(user.uid);

            await needsSnapshot.once().then((DataSnapshot snapshot) async {

              if(snapshot.value != null) {
                storage.setItem("userData", snapshot.value);
                Fluttertoast.showToast(msg:'Login Successful');
                pr.hide();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => customer.Home()),
                        (route) => false);
              }else{

                await FirebaseAuth.instance.signOut();
                Fluttertoast.showToast(msg:'Authentication Fail');
                pr.hide();

              }
            });
          }

      }

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
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
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
                      margin: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                      width: size.width*0.5,
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
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 0,
                            horizontal: 40),
                        width: size.width * 0.9,
                        child: TextFormField(
                          cursorColor: primaryColor,
                          obscureText: true,
                          controller: _passwordController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock_outline,
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
                              return 'Please enter the Password';
                            }
                            return null;
                          },
                        )
                    ),
                    SizedBox(height: size.height * 0.025),
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
                              pr.update(message: "Authenticating...");
                              if (_formKey.currentState.validate()) {
                                await pr.show();
                                authenticateUser(_emailController.text,
                                    _passwordController.text);
                              }
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white,fontSize: size.height*0.02),
                            ),
                          ),
                        )
                    ),
                    Container(
                      height: size.height * 0.01,
                    ),
                    Container(
                      width: size.width*0.8,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return Reset();
                              }));
                        },
                        child: Text(
                          "Forgot password?",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: size.height*0.018,
                            color: primaryColor
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}