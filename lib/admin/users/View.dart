
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:terrain_gym/admin/users/Add.dart';
import 'package:terrain_gym/admin/users/GymUser.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../main.dart';
import 'Update.dart';

class View extends StatefulWidget {
  const View({
    Key key,
  }) : super(key: key);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {

  var _firebaseRef = FirebaseDatabase().reference().child('Users');
  bool data = false;
  final DateTime now = new DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    // the credentials are stored on disk for later use
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  AppBar(
          elevation: 0,
          toolbarHeight: size.height*0.08,
          backgroundColor: primaryColor,
          title: Text("Gym Users",
              style: TextStyle(
                  color: primaryColorDark,
                  fontFamily: "ElMessiri",
                  fontSize: size.height*0.035)
          ),
          centerTitle: true,
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right:5.0),
              child: IconButton(
                icon:FaIcon(
                  FontAwesomeIcons.plus,
                  size: size.width*0.06,
                  color: Colors.white,
                ),
                onPressed: () async {
                  Navigator
                      .of(context)
                      .push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Add()
                      )
                  );
                },
              ),
            )
          ]
      ),
      body:  SafeArea(
        child:Container(
          color: primaryColor,
          width: size.width*1,
          child: StreamBuilder(
            stream: _firebaseRef.onValue,
            builder: (context, snap) {
              if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                //create a map and store the fetched data
                Map data = snap.data.snapshot.value;
                List item = [];
                data.forEach((index, data) => item.add({"key": index, "name": data['name'],"email": data['email'],"phone": data['phone'],"weight": data['weight'],"height": data['height'],"birthDay": data['birthDay'],"attendance": data['Attendance'],"registered": data['registeredOn']}));
                //create a list view
                return ListView.builder(
                  itemCount: item.length,
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                  itemBuilder: (context, index) {
                    bool found = false;
                    DateTime registeredDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(item[index]['registered']);
                    Duration diff = now.difference(registeredDate);
                    if(diff.inDays > 7){
                      for(int i = 0; i < 7; i++) {
                        DateTime currentDate = now.subtract(Duration(days: i));
                        Map attendance = item[index]['attendance']??{};
                        if(attendance.containsKey(currentDate.toString().substring(0,10))){
                            found = true;
                          break;
                        }
                      }
                    }else{
                        found = true;
                    }

                    return Container(
                      margin:const EdgeInsets.only(top:10 ,bottom: 0) ,
                      child: Container(
                          child:Card(
                            color: primaryColor,
                            elevation: 10,
                            child:ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(height: size.height*0.02),
                                  Text(item[index]['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height*0.035,
                                          fontFamily: 'ElMessiri',
                                        height: 1
                                      )
                                    ),
                                  Container(
                                    width: size.width*0.9,
                                    child: Stack(
                                      children: [
                                         Container(
                                           height: size.height*0.03,
                                           child:  Text(item[index]['phone'],
                                               // textAlign: TextAlign.end,
                                               style: TextStyle(
                                                   color: Colors.white38,
                                                   fontSize:  size.height*0.023,
                                                   fontFamily: 'SourceSans',
                                                   height: 1
                                               )
                                           ),
                                         ),
                                        Positioned(
                                          right: 0,
                                            child: Row(
                                              children: [
                                                if(!found)InkWell(
                                                  onTap: (){
                                                      Fluttertoast.showToast(msg: "No attendance within a week");
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.confirm,
                                                          text: "Do you want to send warning message?",
                                                          confirmBtnText: "Yes",
                                                          onConfirmBtnTap: () async {
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                            String id = FirebaseAuth.instance.currentUser.uid.substring(0,5)+DateTime.now().microsecondsSinceEpoch.toString();
                                                            final textMessage = types.TextMessage(
                                                              authorId: FirebaseAuth.instance.currentUser.uid,
                                                              timestamp: (DateTime.now().microsecondsSinceEpoch~/1000).toInt(),
                                                              id: id,
                                                              text: "Hi ${item[index]['name']}, why haven't you visited the gym within a week?",
                                                            );
                                                            FirebaseDatabase().reference().child('Users').child(item[index]['key']).child("Messages").child(id).set(textMessage.toJson());
                                                            Fluttertoast.showToast(msg: "Message sent");
                                                          },
                                                          cancelBtnText: "No",
                                                          confirmBtnColor: Colors.green
                                                      );
                                                    },
                                                  child: FaIcon(
                                                    FontAwesomeIcons.exclamationTriangle,
                                                    size: size.height*0.025,
                                                    color: Colors.redAccent,
                                                  ),
                                                )
                                              ],
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(height: size.height*0.01)
                                ],
                              ),
                              onLongPress: () async {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    text: "Do you want to delete this user?",
                                    confirmBtnText: "Yes",
                                    onConfirmBtnTap: () async {
                                      _firebaseRef.child(item[index]['key']).remove();
                                      Navigator.of(context,rootNavigator: true).pop();

                                    },
                                    cancelBtnText: "No",
                                    confirmBtnColor: Colors.green
                                );
                              },
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return Update(user:new GymUser(item[index]['key'],item[index]['name'], item[index]['email'], item[index]['phone'], double.parse(item[index]['height'].toString()), double.parse(item[index]['weight'].toString()), item[index]['birthDay']));
                                    })).then((value) => setState((){}));
                              },
                            ),
                          )
                      ),
                    );
                  },
                );
              }
              else
                return Container(
                  color: primaryColor,
                );
            },
          ),
        ),
      ),
    );
  }
}

