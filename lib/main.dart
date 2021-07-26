import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:terrain_gym/Splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

const primaryColor = Color(0xFF194769);
const primaryColorDark = Color(0xFFF2855E);
const canvasColor = Color(0x22F2855E);
const accentColor = Color(0xFF6FA6A3);
const accentNewColor = Color(0xFF6FEF8D);
const textFieldColor = Color(0xFFffffff);
