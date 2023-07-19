import 'package:flutter/material.dart';

import 'package:gesture_collection_app/screens/Login_screen.dart';
import 'package:gesture_collection_app/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeechCollectScreen extends StatelessWidget {
  static const String routeName = "/speechcollect";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("",
              style: new TextStyle(
                fontSize: 20.0,
              )),
          Padding(padding: EdgeInsets.all(50.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.grey[300],
                        backgroundColor: Colors.blue,
                        minimumSize: Size(200, 65)),
                    child: Text("Speech",
                        style: new TextStyle(
                          fontSize: 20.0,
                        )),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/speech");
                    }),
              )
            ],
          ),
          Padding(padding: EdgeInsets.all(25.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.grey[300],
                        backgroundColor: Colors.green,
                        minimumSize: Size(200, 65)),
                    child: Text("Collect",
                        style: new TextStyle(
                          fontSize: 20.0,
                        )),
                    onPressed: () {
                      //Navigator.of(context).pushNamed("/library");
                      IFLoggedIn().then((value) {
                        if (value) {
                          print("user logged In");
                          /*Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => SpeechCollectScreen()
                          )*/
                          Navigator.of(context).pushNamed("/library");
                        } else {
                          print("user not logged In");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login_screen(null),
                              ));
                        }
                      });
                    }),
              )
            ],
          ),
        ]),
      ),
    );
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
}
