import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gesture_collection_app/screens/AvailableGestureList.dart';
import 'package:gesture_collection_app/screens/GestureDescription.dart';
import 'package:gesture_collection_app/screens/IndividualGestureScreen.dart';
import 'package:gesture_collection_app/screens/LibraryScreen.dart';
import 'package:gesture_collection_app/screens/LoadingScreen.dart';
import 'package:gesture_collection_app/screens/PlayAudioScreen.dart';
import 'package:gesture_collection_app/screens/SpeechCollectScreen.dart';
import 'package:gesture_collection_app/screens/SpeechScreen.dart';
import 'package:gesture_collection_app/screens/gesture_screen.dart';
import 'package:gesture_collection_app/screens/home_screen.dart';
import 'package:gesture_collection_app/screens/Login_screen.dart';
import 'package:gesture_collection_app/screens/tab_screen.dart';
import 'screens/record_gesture_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: LoadingScreen(),
    routes: <String, WidgetBuilder>{
      TabScreen.routeName: (BuildContext context) => TabScreen(null),
      HomeScreen.routeName: (BuildContext context) => HomeScreen(),
      GestureScreen.routeName: (BuildContext context) => GestureScreen(),
      RecordGestureScreen.routeName: (BuildContext context) =>
          RecordGestureScreen(),
      LoadingScreen.routeName: (BuildContext context) => LoadingScreen(),
      SpeechScreen.routeName: (BuildContext context) => SpeechScreen(),
      SpeechCollectScreen.routeName: (BuildContext context) =>
          SpeechCollectScreen(),
      LibraryScreen.routeName: (BuildContext context) => LibraryScreen(),
      IndividualGestureScreen.routeName: (BuildContext context) =>
          IndividualGestureScreen(""),
      PlayAudioScreen.routeName: (BuildContext context) => PlayAudioScreen(),
      Login_screen.routeName: (BuildContext context) => Login_screen(null),
      GestureDescription.routeName: (BuildContext context) =>
          GestureDescription(),
      AvailableGestureList.routeName: (BuildContext context) =>
          AvailableGestureList()
    },
    theme: ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.white,
      primaryColorDark: Colors.black,

      // Define the default font family.
      fontFamily: 'Montserrat',

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'),
        headline6: TextStyle(
            fontSize: 36.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Montserrat'),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Montserrat'),
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFFF4573)),
    ),
  ));
}


