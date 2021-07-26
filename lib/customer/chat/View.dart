
import 'package:connection_verify/connection_verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import '../../main.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class View extends StatefulWidget {
  const View({
    Key key,
  }) : super(key: key);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  List<types.Message> _messages = [];
  types.User user;
  DatabaseReference _firebaseRef;
  final LocalStorage storage = new LocalStorage('terrain');


  @override
  void initState() {
    // TODO: implement initState
    // the credentials are stored on disk for later use
    super.initState();
    user = types.User(id: FirebaseAuth.instance.currentUser.uid);
    _firebaseRef = FirebaseDatabase().reference().child('Users').child(FirebaseAuth.instance.currentUser.uid).child("Messages");
    getData();
  }

  getData() async {

    if (await ConnectionVerify.connectionStatus()){
      FirebaseDatabase.instance
          .reference()
          .child("Users").child(FirebaseAuth.instance.currentUser.uid).child("Messages").orderByChild("timestamp").onChildAdded.listen((event) {
        var snapshot = event.snapshot.value;
        if(snapshot !=  null) {
          int index = _messages.indexWhere((element) => element.id == snapshot['id']);
          if(index == -1){
            setState(() {
              _messages.insert(0,types.TextMessage(
                authorId: snapshot['authorId'],
                timestamp: snapshot['timestamp'],
                id: snapshot['id'],
                text: snapshot['text'],
              ));
            });
          }
        }
      });
    }else {
      Map userData = storage.getItem("userData")??{};
      Map messagesMap = userData['Messages']??{};
      for (var val in messagesMap.entries) {
        print(val.value);
        int index = _messages.indexWhere((element) => element.id == val.value['id']);
        if(index == -1){
          setState(() {
            _messages.insert(0,types.TextMessage(
              authorId: val.value['authorId'],
              timestamp: val.value['timestamp'],
              id: val.value['id'],
              text: val.value['text'],
            ));
          });
        }
      }
      _messages.sort((a, b)=> b.timestamp.compareTo(a.timestamp));
      Fluttertoast.showToast(msg: "No internet connection");
    }
  }


  Future<void> _handleSendPressed(types.PartialText message) async {
    // getData();
    if (await ConnectionVerify.connectionStatus()) {
      String id = FirebaseAuth.instance.currentUser.uid.substring(0, 5) +
          DateTime
              .now()
              .microsecondsSinceEpoch
              .toString();
      final textMessage = types.TextMessage(
        authorId: FirebaseAuth.instance.currentUser.uid,
        timestamp: (DateTime
            .now()
            .microsecondsSinceEpoch ~/ 1000).toInt(),
        id: id,
        text: message.text,
      );
      print(DateTime.fromMillisecondsSinceEpoch(
        textMessage.timestamp,
      ).toString());
      _firebaseRef.child(id).set(textMessage.toJson());
    }else{
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
          title: Text("Chat",
              style: TextStyle(
                  color: primaryColorDark,
                  fontFamily: "ElMessiri",
                  fontSize: size.height*0.035)
          ),
          centerTitle: true,
        ),
      body: Chat(
        messages: _messages,
        isAttachmentUploading: false,
        onSendPressed: _handleSendPressed,
        user: user,
      )
    );
  }
}

