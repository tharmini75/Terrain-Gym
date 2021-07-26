
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../main.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class View extends StatefulWidget {
  final String id;
  final String name;
  const View({
    Key key,
    this.id,
    this.name,
  }) : super(key: key);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  List<types.Message> _messages = [];
  types.User user;
  DatabaseReference _firebaseRef;


  @override
  void initState() {
    // TODO: implement initState
    // the credentials are stored on disk for later use
    super.initState();
    user = types.User(id: FirebaseAuth.instance.currentUser.uid);
    _firebaseRef = FirebaseDatabase().reference().child('Users').child(widget.id).child("Messages");
    getData();
  }

  getData() async {
    FirebaseDatabase.instance
        .reference()
        .child("Users").child(widget.id).child("Messages").orderByChild("timestamp").onChildAdded.listen((event) {
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
  }

  void _handleSendPressed(types.PartialText message) {
    String id = FirebaseAuth.instance.currentUser.uid.substring(0,5)+DateTime.now().microsecondsSinceEpoch.toString();
    final textMessage = types.TextMessage(
      authorId: FirebaseAuth.instance.currentUser.uid,
      timestamp: (DateTime.now().microsecondsSinceEpoch~/1000).toInt(),
      id: id,
      text: message.text,
    );
    print(DateTime.fromMillisecondsSinceEpoch(
      textMessage.timestamp,
    ).toString());
    _firebaseRef.child(id).set(textMessage.toJson());
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
          title: Text("${widget.name.split(" ")[0]}",
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

