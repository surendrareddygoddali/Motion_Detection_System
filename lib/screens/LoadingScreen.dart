import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:gesture_collection_app/models/TFLiteHelper.dart';
import 'package:gesture_collection_app/screens/dashboard.dart';
import 'package:gesture_collection_app/screens/introduction_screens.dart';

import 'package:gesture_collection_app/services/gesture_service.dart';

import 'package:gesture_collection_app/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  static const String routeName = "/loading";
  //static const platform = const MethodChannel('ondeviceML');
  @override
  State<StatefulWidget> createState() {
    return LoadingState();
  }
}

class LoadingState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
    /*print('Start loading model ');
    TFLiteHelper.loadModel().then((value) {
      setState(() {
        print('LOADED TFLITE');
        TFLiteHelper.modelLoaded = true;

      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Loading..."),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              CircularProgressIndicator(
                backgroundColor: Colors.yellow,
                strokeWidth: 1,
              )
            ])));
  }

  //temporary timer until real loading implemented
  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() {
    print("timer ends");
    /*IFLoggedIn().then((value){
      if(value){
        print("user logged In");
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => SpeechCollectScreen()
        )
        );
      }else {
        print("user not logged In");
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Login_screen()
        )
        );
      }
    });*/
    GestureService.getGesturesList()
        .then((value) => {moveToSpeechScreen(value)});
  }

  Future<void> moveToSpeechScreen(List<QueryDocumentSnapshot> value) async {
    var allGesutures = [];
    value.forEach((QueryDocumentSnapshot snapshot) =>
    {allGesutures.add(snapshot.data())});
    SharedPreferencesService.saveGestureList(allGesutures);
    if (await _isFirstLaunch()) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => IntroductionScreens()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  Future<bool> IFLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    if (userId == null || userId == '') {
      return Future<bool>.value(false);
    } else {
      return Future<bool>.value(true);
    }
  }

  Future<bool> _isFirstLaunch() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = sharedPreferences.getBool("FRESH_INSTALL") ?? true;
    if (isFirstLaunch) sharedPreferences.setBool("FRESH_INSTALL", false);
    return isFirstLaunch;
  }
/*Future<void> _getPredictData() async {
    try {
      final String result =
      await LoadingScreen.platform.invokeMethod('predictData', {"arg": ""});  // passing arguments
      //here inp has our matrix returned by tokenizer class


    } on PlatformException catch (e) {

      print(e.message);
    }
  }*/
}
