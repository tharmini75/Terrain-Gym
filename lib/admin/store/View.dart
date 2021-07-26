
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:terrain_gym/Common.dart';
import 'Add.dart';
import 'Item.dart';

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

  var _firebaseRef = FirebaseDatabase().reference().child('Items');
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
          title: Text("Store Items",
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
          width: size.width,
          child: StreamBuilder(
            stream: _firebaseRef.onValue,
            builder: (context, snap) {
              if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                //create a map and store the fetched data
                Map data = snap.data.snapshot.value;
                List item = [];
                data.forEach((index, data) => item.add({"key": index, "name": data['name'],"price": data['price'],"description": data['description'],"image": data['image']}));
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
                      margin:status?EdgeInsets.only(top: 20,bottom: 0):EdgeInsets.only(top:10 ,bottom: 0) ,
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
                                    alignment: Alignment.centerRight,
                                    child: Text(currencyFormat(item[index]['price'])??"",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontSize:  size.height*0.023,
                                            fontFamily: 'SourceSans',
                                            height: 1
                                        )
                                    ),
                                  ),
                                  Container(height: size.height*0.005)
                                ],
                              ),
                              onLongPress: () async {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    text: "Do you want to delete this item?",
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
                                      return Update(item:new Item(item[index]['key'],item[index]['name'], item[index]['price'], item[index]['description'], item[index]['image']));
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

