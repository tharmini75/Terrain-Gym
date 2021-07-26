
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:terrain_gym/customer/profile/ChangePassword.dart';
import 'package:terrain_gym/customer/profile/ProfileEdit.dart';
import '../../main.dart';
import 'schedules/View.dart' as schedule;
import 'dietPlan/View.dart' as dietPlan;
import '../payments/View.dart' as payments;

class View extends StatefulWidget {
  const View({
    Key key,
  }) : super(key: key);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  final LocalStorage storage = new LocalStorage('terrain');
  Map data = {};

  @override
  void initState() {
    // TODO: implement initState
    // the credentials are stored on disk for later use
    super.initState();
    getData();
  }

  getData(){
    setState(() {
      data = storage.getItem("userData")??{};
    });
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
          title: Text("Profile",
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
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  width: size.width*0.9,
                  child:  Text("Registered on: ${data['registeredOn'].toString().substring(0,10)}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: size.height*0.015,
                        fontFamily: 'GothamMedium',
                        // height: 1
                      )
                  ),
                ),
                Container(height: size.height*0.02),
                Container(
                  margin: const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                  height: size.width*0.6,
                  // width: size.width*0.7,
                  //Display the logo
                  child: new Image.asset('assets/logo.png'),
                ),
                InkWell(
                  onLongPress: (){
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        text: "Do you want to update the profile?",
                        confirmBtnText: "Yes",
                        onConfirmBtnTap: () async {
                          Navigator.of(context,rootNavigator: true).pop();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return ProfileEdit();
                              })).then((value) => getData());

                        },
                        cancelBtnText: "No",
                        confirmBtnColor: Colors.green
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    margin: EdgeInsets.symmetric(horizontal: size.width*0.05),
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.03),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: size.width*0.3,
                              child: Text("Name  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamMedium',
                                    // height: 1
                                  )
                              ),
                            ),
                            Container(
                              width: size.width*0.5,
                              child: Text("${data['name']}",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamBook',
                                    // height: 1
                                  )
                              ),
                            )
                          ],
                        ),
                        Container(height: size.height*0.03),
                        Row(
                          children: [
                            Container(
                              width: size.width*0.3,
                              child: Text("Date of Birth  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamMedium',
                                    // height: 1
                                  )
                              ),
                            ),
                            Container(
                              width: size.width*0.5,
                              child: Text("${data['birthDay']}",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamBook',
                                    // height: 1
                                  )
                              ),
                            )
                          ],
                        ),
                        Container(height: size.height*0.03),
                        Row(
                          children: [
                            Container(
                              width: size.width*0.3,
                              child: Text("Mobile No ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamMedium',
                                    // height: 1
                                  )
                              ),
                            ),
                            Container(
                              width: size.width*0.5,
                              child: Text("${data['phone']}",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamBook',
                                    // height: 1
                                  )
                              ),
                            )
                          ],
                        ),
                        Container(height: size.height*0.03),
                        Row(
                          children: [
                            Container(
                              width: size.width*0.3,
                              child: Text("Email ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamMedium',
                                    // height: 1
                                  )
                              ),
                            ),
                            Container(
                              width: size.width*0.5,
                              child: Text("${data['email']}",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamBook',
                                    // height: 1
                                  )
                              ),
                            )
                          ],
                        ),
                        Container(height: size.height*0.03),
                        Row(
                          children: [
                            Container(
                              width: size.width*0.3,
                              child: Text("Height ",
                                  style: TextStyle(
                                    color: primaryColorDark,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamMedium',
                                    // height: 1
                                  )
                              ),
                            ),
                            Container(
                              width: size.width*0.5,
                              child: Text("${data['height']} cm",
                                  style: TextStyle(
                                    color: primaryColorDark,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamBook',
                                    // height: 1
                                  )
                              ),
                            )
                          ],
                        ),
                        Container(height: size.height*0.03),
                        Row(
                          children: [
                            Container(
                              width: size.width*0.3,
                              child: Text("Weight ",
                                  style: TextStyle(
                                    color: primaryColorDark,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamMedium',
                                    // height: 1
                                  )
                              ),
                            ),
                            Container(
                              width: size.width*0.5,
                              child: Text("${data['weight']} Kg",
                                  style: TextStyle(
                                    color: primaryColorDark,
                                    fontSize: size.height*0.02,
                                    fontFamily: 'GothamBook',
                                    // height: 1
                                  )
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height*0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height*0.3,
                        width: size.width*0.425,
                        padding: EdgeInsets.symmetric(vertical: size.height*0.02),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return schedule.View();
                                }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.dumbbell,
                                  color: Color(0xFF6FEF8D),
                                  size: size.height*0.06,
                                ),
                                Container(height:size.height*0.02),
                                Container(
                                  child: Text(
                                    "Schedule",
                                    style: TextStyle(
                                        fontSize: size.height*0.02,
                                        color: Color(0xFF6FEF8D),
                                        fontFamily: "SourceSans"
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(width: size.width*0.05),
                      Container(
                        height: size.height*0.3,
                        width: size.width*0.425,
                        padding: EdgeInsets.symmetric(vertical: size.height*0.02),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return dietPlan.View();
                                }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.utensils,
                                  color: primaryColorDark,
                                  size: size.height*0.06,
                                ),
                                Container(height:size.height*0.02),
                                Container(
                                  child: Text(
                                    "Diet Plan",
                                    style: TextStyle(
                                        fontSize: size.height*0.02,
                                        color: primaryColorDark,
                                        fontFamily: "SourceSans"
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return payments.View();
                        }));
                  },
                  child: Container(
                    width: size.width*0.9,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    padding: EdgeInsets.all(size.height*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "Your Payments",
                            style: TextStyle(
                                fontSize: size.height*0.028,
                                color: accentNewColor,
                                fontFamily: "GothamMedium"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(height: size.height*0.02),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return ChangePassword();
                        })).then((value) => getData());
                  },
                  child: Container(
                    width: size.width*0.9,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    padding: EdgeInsets.all(size.height*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // FaIcon(
                        //   FontAwesomeIcons.signOutAlt,
                        //   color: primaryColorDark,
                        //   size: size.height*0.04,
                        // ),
                        // Container(width: size.width*0.04),
                        Container(
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                                fontSize: size.height*0.028,
                                color: primaryColorDark,
                                fontFamily: "GothamMedium"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(height: size.height*0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

