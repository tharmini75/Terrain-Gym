import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../main.dart';

class View extends StatefulWidget {
  final String id;
  const View({
    Key key,
    this.id
  }) : super(key: key);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  final _timeController = TextEditingController();
  final _foodController = TextEditingController();
  final _weightController = TextEditingController();
  final _dayController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DatabaseReference _firebaseRef;
  List times = ['Breakfast','Lunch','Dinner'];
  List days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];

  @override
  void initState() {
    // TODO: implement initState
    _firebaseRef = FirebaseDatabase().reference().child('Users').child(widget.id).child("DietPlan");
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
          title: Text("Diet Plan",
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
          width: size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: size.height*0.03),
                Container(
                  width: size.width*0.9,
                  child: Text("Add Diet Plan",
                      style: TextStyle(
                          color: primaryColorDark,
                          fontFamily: "ElMessiri",
                          fontSize: size.height*0.03)
                  ),
                ),
                Container(
                  // height: size.height*0.2,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(height: size.height*0.01),
                        Container(
                          width: size.width*0.9,
                          child: TextFormField(
                            controller: _foodController,
                            cursorColor: primaryColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Food Name",
                              hintStyle: TextStyle(fontSize: size.height*0.018,color: Colors.black26),
                              border: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                                //borderSide: const BorderSide(),
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(size.height*0.012),
                              fillColor:textFieldColor,
                              errorStyle: TextStyle(
                                color: Theme.of(context).errorColor, // or any other color
                              ),
                            ),
                            style: TextStyle(
                                fontSize: size.height*0.018
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Food Name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(height: size.height*0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width*0.44,
                              child: PopupMenuButton<String>(
                                child:Container(
                                    margin: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: 0),
                                    width: size.width * 0.45,
                                    child:TextFormField(
                                      controller: _dayController,
                                      cursorColor: primaryColor,
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Select the day",
                                        hintStyle: TextStyle(fontSize: size.height*0.018,color: Colors.black26),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide: BorderSide.none,
                                          //borderSide: const BorderSide(),
                                        ),
                                        filled: true,
                                        contentPadding:EdgeInsets.all(size.height*0.012),
                                        fillColor:textFieldColor,
                                        errorStyle: TextStyle(
                                          color: Theme.of(context).errorColor, // or any other color
                                        ),
                                      ),
                                      style: TextStyle(
                                          fontSize: size.height*0.018
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Day can\'t be empty';
                                        }
                                        return null;
                                      },
                                    )
                                ),
                                onSelected: (value){
                                  setState(() {
                                    _dayController.text = value;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return days.map((dynamic choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            Container(width: size.width*0.02),
                            Container(
                              width: size.width*0.44,
                              child: PopupMenuButton<String>(
                                child:Container(
                                    margin: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: 0),
                                    width: size.width * 0.45,
                                    child:TextFormField(
                                      controller: _timeController,
                                      cursorColor: primaryColor,
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Select the time",
                                        hintStyle: TextStyle(fontSize: size.height*0.018,color: Colors.black26),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide: BorderSide.none,
                                          //borderSide: const BorderSide(),
                                        ),
                                        filled: true,
                                        contentPadding:EdgeInsets.all(size.height*0.012),
                                        fillColor:textFieldColor,
                                        errorStyle: TextStyle(
                                          color: Theme.of(context).errorColor, // or any other color
                                        ),
                                      ),
                                      style: TextStyle(
                                          fontSize: size.height*0.018
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Time can\'t be empty';
                                        }
                                        return null;
                                      },
                                    )
                                ),
                                onSelected: (value){
                                  setState(() {
                                    _timeController.text = value;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  return times.map((dynamic choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(height: size.height*0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width*0.44,
                              child: TextFormField(
                                controller: _weightController,
                                cursorColor: primaryColor,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Weight (g/ml)",
                                  hintStyle: TextStyle(fontSize: size.height*0.018,color: Colors.black26),
                                  border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide.none,
                                    //borderSide: const BorderSide(),
                                  ),
                                  filled: true,
                                  contentPadding:EdgeInsets.all(size.height*0.012),
                                  fillColor:textFieldColor,
                                  errorStyle: TextStyle(
                                    color: Theme.of(context).errorColor, // or any other color
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: size.height*0.018
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Weight can\'t be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(width: size.width*0.02),
                            Container(
                              width: size.width*0.44,
                              child:  ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: size.height*0.019, horizontal: 40),
                                  color: primaryColorDark,
                                  onPressed: () async {
                                    if (FocusScope.of(context).isFirstFocus) {
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                    }
                                    if (_formKey.currentState.validate()) {
                                      _firebaseRef.child(_dayController.text).push().set({
                                        "name": _foodController.text,
                                        "weight": _weightController.text,
                                        "time": _timeController.text,
                                      });
                                      Fluttertoast.showToast(msg: "Food Item added");
                                      setState(() {
                                        _foodController.text = "";
                                        _weightController.text = "";
                                        _dayController.text = "";
                                        _timeController.text = "";
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white,fontSize: size.height*0.018),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(height: size.height*0.03),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height*0.5,
                  child: DefaultTabController(
                    length: 7,
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: Colors.transparent,
                      appBar:TabBar(
                        isScrollable: false,
                        unselectedLabelColor: Colors.white38,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(fontFamily: "RobotoMedium"),
                        tabs: [
                          Tab(text: "Sun"),
                          Tab(text: "Mon"),
                          Tab(text: "Tue"),
                          Tab(text: "Wed"),
                          Tab(text: "Thu"),
                          Tab(text: "Fri"),
                          Tab(text: "Sat"),
                        ],
                      ),
                      body:TabBarView(
                        children: [
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                            color: Colors.white
                                          ),
                                        width: size.width*0.4-1,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Food Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              color: Colors.white
                                          ),
                                        width: size.width*0.2-1,
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Weight",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: size.height*0.028,
                                        color: primaryColor,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              color: Colors.white
                                          ),
                                        width: size.width*0.25,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Time",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.1-1,
                                        // height: size.height*0.028,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.height*0.35,
                                  child: StreamBuilder(
                                    stream: _firebaseRef.child(days[0]).onValue,
                                    builder: (context, snap) {
                                      if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                                        //create a map and store the fetched data
                                        Map data = snap.data.snapshot.value;
                                        List foods = [];
                                        data.forEach((index, data) => foods.add({"key": index, "name": data['name'],"weight": data['weight'],"time": data['time']}));
                                        List item = [];
                                        for(var j=0;j < times.length; j++) {
                                          for (var i = 0; i < foods.length; i++) {
                                            if (foods[i]['time'] == times[j]) {
                                              item.add(foods[i]);
                                            }
                                          }
                                        }
                                        //create a list view
                                        return ListView.builder(
                                          itemCount: item.length,
                                          padding: EdgeInsets.symmetric(horizontal: size.width*0.025),
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: size.height*0.045,
                                                  alignment: Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.4,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.2,
                                                  height: size.height*0.045,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['weight']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.25,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['time']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.1,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: InkWell(
                                                    onTap:(){
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.confirm,
                                                          text: "Do you want to delete this item?",
                                                          confirmBtnText: "Yes",
                                                          onConfirmBtnTap: () async {
                                                            _firebaseRef.child(days[0]).child(item[index]['key']).remove();
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                          },
                                                          cancelBtnText: "No",
                                                          confirmBtnColor: Colors.green
                                                      );
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.times,
                                                      color:Colors.white,
                                                      size: size.height*0.017,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.4-1,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Food Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2-1,
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Weight",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: size.height*0.028,
                                        color: primaryColor,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.25,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Time",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.1-1,
                                        // height: size.height*0.028,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.height*0.35,
                                  child: StreamBuilder(
                                    stream: _firebaseRef.child(days[1]).onValue,
                                    builder: (context, snap) {
                                      if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                                        //create a map and store the fetched data
                                        Map data = snap.data.snapshot.value;
                                        List foods = [];
                                        data.forEach((index, data) => foods.add({"key": index, "name": data['name'],"weight": data['weight'],"time": data['time']}));
                                        List item = [];
                                        for(var j=0;j < times.length; j++) {
                                          for (var i = 0; i < foods.length; i++) {
                                            if (foods[i]['time'] == times[j]) {
                                              item.add(foods[i]);
                                            }
                                          }
                                        }
                                        //create a list view
                                        return ListView.builder(
                                          itemCount: item.length,
                                          padding: EdgeInsets.symmetric(horizontal: size.width*0.025),
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: size.height*0.045,
                                                  alignment: Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.4,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.2,
                                                  height: size.height*0.045,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['weight']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.25,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['time']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.1,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: InkWell(
                                                    onTap:(){
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.confirm,
                                                          text: "Do you want to delete this item?",
                                                          confirmBtnText: "Yes",
                                                          onConfirmBtnTap: () async {
                                                            _firebaseRef.child(days[1]).child(item[index]['key']).remove();
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                          },
                                                          cancelBtnText: "No",
                                                          confirmBtnColor: Colors.green
                                                      );
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.times,
                                                      color:Colors.white,
                                                      size: size.height*0.017,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.4-1,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Food Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2-1,
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Weight",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: size.height*0.028,
                                        color: primaryColor,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.25,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Time",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.1-1,
                                        // height: size.height*0.028,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.height*0.35,
                                  child: StreamBuilder(
                                    stream: _firebaseRef.child(days[2]).onValue,
                                    builder: (context, snap) {
                                      if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                                        //create a map and store the fetched data
                                        Map data = snap.data.snapshot.value;
                                        List foods = [];
                                        data.forEach((index, data) => foods.add({"key": index, "name": data['name'],"weight": data['weight'],"time": data['time']}));
                                        List item = [];
                                        for(var j=0;j < times.length; j++) {
                                          for (var i = 0; i < foods.length; i++) {
                                            if (foods[i]['time'] == times[j]) {
                                              item.add(foods[i]);
                                            }
                                          }
                                        }
                                        //create a list view
                                        return ListView.builder(
                                          itemCount: item.length,
                                          padding: EdgeInsets.symmetric(horizontal: size.width*0.025),
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: size.height*0.045,
                                                  alignment: Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.4,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.2,
                                                  height: size.height*0.045,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['weight']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.25,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['time']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.1,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: InkWell(
                                                    onTap:(){
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.confirm,
                                                          text: "Do you want to delete this item?",
                                                          confirmBtnText: "Yes",
                                                          onConfirmBtnTap: () async {
                                                            _firebaseRef.child(days[2]).child(item[index]['key']).remove();
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                          },
                                                          cancelBtnText: "No",
                                                          confirmBtnColor: Colors.green
                                                      );
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.times,
                                                      color:Colors.white,
                                                      size: size.height*0.017,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.4-1,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Food Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2-1,
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Weight",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: size.height*0.028,
                                        color: primaryColor,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.25,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Time",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.1-1,
                                        // height: size.height*0.028,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.height*0.35,
                                  child: StreamBuilder(
                                    stream: _firebaseRef.child(days[3]).onValue,
                                    builder: (context, snap) {
                                      if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                                        //create a map and store the fetched data
                                        Map data = snap.data.snapshot.value;
                                        List foods = [];
                                        data.forEach((index, data) => foods.add({"key": index, "name": data['name'],"weight": data['weight'],"time": data['time']}));
                                        List item = [];
                                        for(var j=0;j < times.length; j++) {
                                          for (var i = 0; i < foods.length; i++) {
                                            if (foods[i]['time'] == times[j]) {
                                              item.add(foods[i]);
                                            }
                                          }
                                        }
                                        //create a list view
                                        return ListView.builder(
                                          itemCount: item.length,
                                          padding: EdgeInsets.symmetric(horizontal: size.width*0.025),
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: size.height*0.045,
                                                  alignment: Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.4,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.2,
                                                  height: size.height*0.045,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['weight']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.25,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['time']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.1,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: InkWell(
                                                    onTap:(){
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.confirm,
                                                          text: "Do you want to delete this item?",
                                                          confirmBtnText: "Yes",
                                                          onConfirmBtnTap: () async {
                                                            _firebaseRef.child(days[3]).child(item[index]['key']).remove();
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                          },
                                                          cancelBtnText: "No",
                                                          confirmBtnColor: Colors.green
                                                      );
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.times,
                                                      color:Colors.white,
                                                      size: size.height*0.017,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.4-1,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Food Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2-1,
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Weight",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: size.height*0.028,
                                        color: primaryColor,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.25,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Time",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.1-1,
                                        // height: size.height*0.028,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.height*0.35,
                                  child: StreamBuilder(
                                    stream: _firebaseRef.child(days[4]).onValue,
                                    builder: (context, snap) {
                                      if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                                        //create a map and store the fetched data
                                        Map data = snap.data.snapshot.value;
                                        List foods = [];
                                        data.forEach((index, data) => foods.add({"key": index, "name": data['name'],"weight": data['weight'],"time": data['time']}));
                                        List item = [];
                                        for(var j=0;j < times.length; j++) {
                                          for (var i = 0; i < foods.length; i++) {
                                            if (foods[i]['time'] == times[j]) {
                                              item.add(foods[i]);
                                            }
                                          }
                                        }
                                        //create a list view
                                        return ListView.builder(
                                          itemCount: item.length,
                                          padding: EdgeInsets.symmetric(horizontal: size.width*0.025),
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: size.height*0.045,
                                                  alignment: Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.4,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.2,
                                                  height: size.height*0.045,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['weight']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.25,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['time']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.1,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: InkWell(
                                                    onTap:(){
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.confirm,
                                                          text: "Do you want to delete this item?",
                                                          confirmBtnText: "Yes",
                                                          onConfirmBtnTap: () async {
                                                            _firebaseRef.child(days[4]).child(item[index]['key']).remove();
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                          },
                                                          cancelBtnText: "No",
                                                          confirmBtnColor: Colors.green
                                                      );
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.times,
                                                      color:Colors.white,
                                                      size: size.height*0.017,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.4-1,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Food Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2-1,
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Weight",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: size.height*0.028,
                                        color: primaryColor,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.25,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Time",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.1-1,
                                        // height: size.height*0.028,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.height*0.35,
                                  child: StreamBuilder(
                                    stream: _firebaseRef.child(days[5]).onValue,
                                    builder: (context, snap) {
                                      if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                                        //create a map and store the fetched data
                                        Map data = snap.data.snapshot.value;
                                        List foods = [];
                                        data.forEach((index, data) => foods.add({"key": index, "name": data['name'],"weight": data['weight'],"time": data['time']}));
                                        List item = [];
                                        for(var j=0;j < times.length; j++) {
                                          for (var i = 0; i < foods.length; i++) {
                                            if (foods[i]['time'] == times[j]) {
                                              item.add(foods[i]);
                                            }
                                          }
                                        }
                                        //create a list view
                                        return ListView.builder(
                                          itemCount: item.length,
                                          padding: EdgeInsets.symmetric(horizontal: size.width*0.025),
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: size.height*0.045,
                                                  alignment: Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.4,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.2,
                                                  height: size.height*0.045,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['weight']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.25,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['time']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.1,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: InkWell(
                                                    onTap:(){
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.confirm,
                                                          text: "Do you want to delete this item?",
                                                          confirmBtnText: "Yes",
                                                          onConfirmBtnTap: () async {
                                                            _firebaseRef.child(days[5]).child(item[index]['key']).remove();
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                          },
                                                          cancelBtnText: "No",
                                                          confirmBtnColor: Colors.green
                                                      );
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.times,
                                                      color:Colors.white,
                                                      size: size.height*0.017,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width*0.95,
                            child: Column(
                              children: [
                                Container(
                                  height: size.height*0.06,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.4-1,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Food Name",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.2-1,
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Weight",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: size.height*0.028,
                                        color: primaryColor,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.25,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("Time",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: primaryColor,
                                        height: size.height*0.028,
                                      ),
                                      Container(
                                        height: size.height*0.045,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            color: Colors.white
                                        ),
                                        width: size.width*0.1-1,
                                        // height: size.height*0.028,
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                        child: Text("",
                                            style: TextStyle(
                                                color:primaryColor,
                                                fontSize: size.height*0.018,
                                                height: 1
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: size.height*0.35,
                                  child: StreamBuilder(
                                    stream: _firebaseRef.child(days[6]).onValue,
                                    builder: (context, snap) {
                                      if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                                        //create a map and store the fetched data
                                        Map data = snap.data.snapshot.value;
                                        List foods = [];
                                        data.forEach((index, data) => foods.add({"key": index, "name": data['name'],"weight": data['weight'],"time": data['time']}));
                                        List item = [];
                                        for(var j=0;j < times.length; j++) {
                                          for (var i = 0; i < foods.length; i++) {
                                            if (foods[i]['time'] == times[j]) {
                                              item.add(foods[i]);
                                            }
                                          }
                                        }
                                        //create a list view
                                        return ListView.builder(
                                          itemCount: item.length,
                                          padding: EdgeInsets.symmetric(horizontal: size.width*0.025),
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: size.height*0.045,
                                                  alignment: Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.4,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['name']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.2,
                                                  height: size.height*0.045,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['weight']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.25,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: Text("${item[index]['time']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.height*0.018,
                                                          height: 1
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height*0.045,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  width: size.width*0.1,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                                  child: InkWell(
                                                    onTap:(){
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.confirm,
                                                          text: "Do you want to delete this item?",
                                                          confirmBtnText: "Yes",
                                                          onConfirmBtnTap: () async {
                                                            _firebaseRef.child(days[6]).child(item[index]['key']).remove();
                                                            Navigator.of(context,rootNavigator: true).pop();
                                                          },
                                                          cancelBtnText: "No",
                                                          confirmBtnColor: Colors.green
                                                      );
                                                    },
                                                    child: FaIcon(
                                                      FontAwesomeIcons.times,
                                                      color:Colors.white,
                                                      size: size.height*0.017,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

