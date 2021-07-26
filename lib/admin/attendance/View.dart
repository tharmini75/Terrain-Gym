
import 'package:connection_verify/connection_verify.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../main.dart';

class View extends StatefulWidget {
  const View({
    Key key,
  }) : super(key: key);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  final LocalStorage storage = new LocalStorage('terrain');
  final DateTime now = new DateTime.now();
  String selectedDate;
  final DateFormat formatter = DateFormat('MMM yyyy');
  Map attendance = {};
  final CalendarController controller = new CalendarController();
  Map<DateTime,List<dynamic>> events = {};
  List selectedData = [];

  @override
  void initState() {
    // TODO: implement initState
    // the credentials are stored on disk for later use
    super.initState();
    selectedDate = now.toString().substring(0,10);
    getData();
  }

  getData() async {
    events.clear();
    if (await ConnectionVerify.connectionStatus()){
      Query needsSnapshot = FirebaseDatabase.instance
          .reference()
          .child('Attendance');

      await needsSnapshot.once().then((DataSnapshot snapshot) {
        if(snapshot.value != null) {
          for (var val in snapshot.value.entries) {
            // print(val.value);
            setState(() {
              events.putIfAbsent(new DateFormat("yyyy-MM-dd").parse(val.key), () => [val.value]);
            });
          }
          DateTime now = new DateTime.now();
          DateTime date = new DateTime(now.year, now.month, now.day);
          if(events.containsKey(date)){
            selectedData.clear();
            setState(() {
              events[date][0].forEach((index, data) => selectedData.add({"key": index, "start": data['start'],"end": data['end']}));
              print(selectedData);
            });
          }
        }
      });
    }else {
      Map userData = storage.getItem("userData")??{};
      Map attendanceMap = userData['Attendance']??{};
      for (var val in attendanceMap.entries) {
        print(val.value);
        setState(() {
          selectedData.clear();
          events.putIfAbsent(new DateFormat("yyyy-MM-dd").parse(val.key), () => [val.value]);
        });
      }
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      if(events.containsKey(date)){
        setState(() {
          events[date][0].forEach((index, data) => selectedData.add({"key": index, "start": data['start'],"end": data['end']}));
        });
      }
      Fluttertoast.showToast(msg: "No internet connection");
    }
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
          title: Text("Attendance",
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
            child: Column(
              children: [
                Container(
                  // height: size.height*0.5,
                  child: TableCalendar(
                    startDay: DateTime.utc(2010, 10, 16),
                    endDay: DateTime.now(),
                    headerStyle: HeaderStyle(titleTextStyle: TextStyle(color: Colors.white),formatButtonVisible: false,leftChevronIcon: Icon(Icons.arrow_back_ios,color: Colors.white),rightChevronIcon: Icon(Icons.arrow_forward_ios,color: Colors.white)),
                    initialSelectedDay: DateTime.now(),
                    daysOfWeekStyle: DaysOfWeekStyle(weekdayStyle: TextStyle(color: Colors.white)),
                    calendarStyle: CalendarStyle(todayColor: Colors.transparent,selectedColor: Colors.white24,weekdayStyle: TextStyle(color: Colors.white,fontFamily: "GothamMedium"),eventDayStyle: TextStyle(color: accentNewColor,fontWeight: FontWeight.bold),markersColor: Colors.yellow,canEventMarkersOverflow: false),
                    calendarController: controller,
                    events: events,
                    onDaySelected: (date,List dayEvents,holidays){
                      print(date.toString());
                      if(dayEvents.isNotEmpty){
                        selectedData.clear();
                        setState(() {
                          dayEvents[0].forEach((index, data) => selectedData.add({"key": index, "start": data['start'],"end": data['end']}));
                          print(selectedData);
                        });
                      }else{

                        setState(() {
                          selectedData.clear();
                        });
                      }
                    },
                  ),
                ),
                (selectedData.isNotEmpty)?Container(
                  // height: size.height*0.1,
                  width: size.width*0.9,
                  padding: EdgeInsets.symmetric(vertical: size.height*0.03),
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: new NeverScrollableScrollPhysics(),
                      itemCount: selectedData.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                            margin: EdgeInsets.only(top: size.height*0.02),
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            padding: EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.02),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: FutureBuilder(
                                      future: getName(selectedData[index]['key']),
                                      initialData: "-",
                                      builder: (BuildContext context, AsyncSnapshot<String> text) {
                                        return Text(
                                          "${text.data}",
                                          style: TextStyle(
                                              fontFamily: "GothamMedium",
                                              fontSize: size.height*0.022,
                                              color: Colors.white
                                          ),
                                        );
                                      }
                                  )
                                ),
                                Container(height: size.height*0.01),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Arrived at : ${selectedData[index]['start']}",
                                    style: TextStyle(
                                        fontFamily: "GothamBook",
                                        fontSize: size.height*0.018,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                Container(height: size.height*0.005),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Leaved at : ${selectedData[index]['end']??'-'}",
                                    style: TextStyle(
                                        fontFamily: "GothamBook",
                                        fontSize: size.height*0.018,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                  )
                ):Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getName(id) async{
    String name = (await FirebaseDatabase.instance.reference().child('Users/$id/name').once()).value;
    return name;
  }
}

