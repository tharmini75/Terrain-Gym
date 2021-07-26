
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'View.dart';
import '../../main.dart';

class ChatList extends StatefulWidget {
  const ChatList({
    Key key,
  }) : super(key: key);
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  var _firebaseRef = FirebaseDatabase().reference().child('Users');
  bool data = false;

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
          title: Text("Chat List",
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
          child: StreamBuilder(
            stream: _firebaseRef.onValue,
            builder: (context, snap) {
              if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                //create a map and store the fetched data
                Map data = snap.data.snapshot.value;
                List item = [];
                data.forEach((index, data) => item.add({"key": index, "name": data['name'],"messages": data['Messages']??{}}));
                //create a list view
                return ListView.builder(
                  itemCount: item.length,
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                  itemBuilder: (context, index) {
                    bool status = false;
                    if(index == 0){
                      status = true;
                    }
                    return Container(
                      margin:status?const EdgeInsets.only(top: 20,bottom: 0):const EdgeInsets.only(top:10 ,bottom: 0) ,
                      child: Container(
                          child:Card(
                            color: primaryColor,
                            elevation: 10,
                            child:ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(height: size.height*0.015),
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        width: size.width*0.8,
                                        child: Text(item[index]['name'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.height*0.035,
                                                fontFamily: 'ElMessiri',
                                                height: 1
                                            )
                                        ),
                                      ),
                                      if(item[index]['messages'].length != 0)Positioned(
                                        right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(size.height*0.006),
                                            decoration: new BoxDecoration(
                                              color: accentNewColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text("${item[index]['messages'].length}",
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: size.height*0.016,
                                                    fontFamily: 'GothamMedium',
                                                    height: 1
                                                )
                                            ),
                                          ),
                                      )
                                    ],
                                  ),
                                  Container(height: size.height*0.01)
                                ],
                              ),
                              onTap: (){
                                Navigator
                                    .of(context)
                                    .push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => View(id:item[index]['key'],name:item[index]['name'])
                                    )
                                );
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

