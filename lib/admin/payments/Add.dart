import 'dart:ffi';
import 'dart:io';
import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:time_machine/time_machine.dart';

import '../../main.dart';
import '../../Common.dart';


class Add extends StatefulWidget {
  final String id;
  final String date;
  const Add({
    Key key,
    this.id,
    this.date
  }) : super(key: key);
  @override
  _AddState createState() => new _AddState();
}
class _AddState extends State<Add> {
  ProgressDialog pr;
  var _firebaseRef = FirebaseDatabase().reference().child('Users');
  List months = [];
  List data = [];
  final DateFormat formatter = DateFormat('MMM yyyy');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOldPayments();
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
            title: Text("Add Payment",
                style: TextStyle(
                    color: primaryColorDark,
                    fontFamily: "ElMessiri",
                    fontSize: size.height*0.035)
            ),
            centerTitle: true,
        ),
        body:SafeArea(
            child:  Container(
                alignment: Alignment.topCenter,
                child:SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      Container(
                        height: size.height*0.06,
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  color: Colors.white
                              ),
                              width: size.width*0.4-1,
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                              child: Text("Month",
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
                              width: size.width*0.3-1,
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                              child: Text("Paid Date",
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
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  color: Colors.white
                              ),
                              width: size.width*0.15,
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                              child: Text("",
                                  textAlign: TextAlign.center,
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
                        // margin: EdgeInsets.all(size.width*0.02),
                        height: size.height*0.8,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          // physics: new NeverScrollableScrollPhysics(),
                          itemCount: months.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(

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
                                      ),
                                      width: size.width*0.4,
                                      padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                      child: Text(
                                          '${formatter.format(new DateFormat("yyyy-MM").parse(months[index]['month']))}',
                                          style: TextStyle(
                                              color:Colors.white,
                                              fontSize: size.height*0.018,
                                              height: 1
                                          )
                                      ),
                                    ),
                                    Container(
                                      height: size.height*0.045,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      width: size.width*0.3,
                                      padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                      child: Text(
                                          (data.any((element) => element['month'] == months[index]['month']))?'${data.firstWhere((element) => element['month'] == months[index]['month'])['date']}':'',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color:Colors.white,
                                              fontSize: size.height*0.018,
                                              height: 1
                                          )
                                      ),
                                    ),
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //       border: Border.all(
                                    //         color: Colors.white,
                                    //       ),
                                    //       color: Colors.white
                                    //   ),
                                    //   width: size.width*0.3-1,
                                    //   padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.01),
                                    //   child: Text(
                                    //     (data.any((element) => element['month'] == months[index]['month']))?'${data.firstWhere((element) => element['month'] == months[index]['month'])['date']}':'',
                                    //     style: new TextStyle(
                                    //         fontSize: size.height*0.018,
                                    //         fontFamily: "SourceSans",
                                    //         color: Colors.white70
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      height: size.height*0.045,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      width: size.width*0.15,
                                      padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                      child: Container(
                                        height: size.height*0.028,
                                        width: size.height*0.028,
                                        child: Transform.scale(
                                          scale: 1,
                                          child: Checkbox(
                                            value: months[index]['checked'],
                                            activeColor: accentNewColor,
                                            onChanged: (value){
                                              if(!value){
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.confirm,
                                                    text: "Do you want to remove the payment?",
                                                    confirmBtnText: "Yes",
                                                    onConfirmBtnTap: () async {
                                                      Navigator.of(context,rootNavigator: true).pop();
                                                      _firebaseRef.child(widget.id).child("Payments").child(months[index]['month']).set(null);
                                                      int dataIndex = data.indexWhere((element) => element['month'] == months[index]['month']);
                                                      setState(() {
                                                        months[index]['checked'] = value;
                                                        data.removeAt(dataIndex);
                                                      });
                                                    },
                                                    cancelBtnText: "No",
                                                    confirmBtnColor: Colors.green
                                                );
                                              }else{
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.confirm,
                                                    text: "Do you want to mark ${formatter.format(new DateFormat("yyyy-MM").parse(months[index]['month']))} as paid?",
                                                    confirmBtnText: "Yes",
                                                    onConfirmBtnTap: () async {
                                                      Navigator.of(context,rootNavigator: true).pop();
                                                      Fluttertoast.showToast(msg: "Select the paid date");
                                                      DateTime now = new DateTime.now();
                                                      DateTime date = new DateTime(now.year, now.month, now.day);
                                                      DatePicker.showDatePicker(context,
                                                          showTitleActions: true,
                                                          maxTime: date,
                                                          theme: DatePickerTheme(
                                                              headerColor: primaryColorDark,
                                                              backgroundColor: primaryColor,
                                                              itemStyle: TextStyle(
                                                                  color: Colors.white,
                                                                  fontFamily: "ElMessiri",
                                                                  fontWeight: FontWeight.bold, fontSize: 18),
                                                              doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                                          onConfirm: (date) {
                                                            _firebaseRef.child(widget.id).child("Payments").child(months[index]['month']).set({
                                                              "date" : date.toString().substring(0,10),
                                                              "month" : months[index]['month']
                                                            });
                                                            setState(() {
                                                              months[index]['checked'] = value;
                                                              data.add({
                                                                "date" : date.toString().substring(0,10),
                                                                "month" : months[index]['month']
                                                              });
                                                            });
                                                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                                                    },
                                                    cancelBtnText: "No",
                                                    confirmBtnColor: Colors.green
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        ),
                      )
                    ],
                  ),
                )
            )
        )
    );

  }

  getOldPayments() async {
    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.date);
    LocalDate nowDate = LocalDate.today();
    LocalDate firstDate = LocalDate.dateTime(tempDate);
    Period diff = nowDate.periodSince(firstDate);

    int difference = diff.months + (diff.years*12) + 1;

    for(var i = 0; i < difference ; i++){
      DateTime date = new DateTime(tempDate.year,tempDate.month+i);
      Map month = {};
      month.putIfAbsent("checked", () => false);
      month.putIfAbsent("month", () => "${date.year}-${date.month}");
      months.add(month);
    }

    for(var i = difference; i < difference + 12 ; i++){
      DateTime date = new DateTime(tempDate.year,tempDate.month+i);
      Map month = {};
      month.putIfAbsent("checked", () => false);
      month.putIfAbsent("month", () => "${date.year}-${date.month}");
      setState(() {
        months.add(month);
      });
    }

    Query needsSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("Users").child(widget.id).child("Payments")
        .orderByKey();

    await needsSnapshot.once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      if(snapshot.value != null) {
        for (var val in snapshot.value.entries) {
          print(val.value['month']);
          data.add(val.value);
          int index = months.indexWhere((element) => element['month'] == val.value['month']);
          if(index != -1){
            setState(() {
              months[index]['checked'] = true;
            });
          }
        }
      }
    });
    print(months);
  }
}

