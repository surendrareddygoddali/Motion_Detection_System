import 'package:flutter/material.dart';
import 'package:gesture_collection_app/widgets/top_nav_bar.dart';

class SpeechScreen extends StatelessWidget {
  static const String routeName = "/speech";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopNavBarWidget(
          height: 300,
          title: "",
          backlink: "/speechcollect",
          actionEnabled: true,
          navEnabled: true,
        ),
        body: Container(
          child: Column(
            children: [
              Center(
                child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.grey[300],
                        backgroundColor: Colors.green,
                        minimumSize: Size(200, 65)),
                    child: Text("Available Gestures",
                        style: new TextStyle(
                          fontSize: 20.0,
                        )),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/availableGestureList");
                    }),
              ),
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
                      Navigator.of(context).pushNamed("/recordgesture",
                          arguments: {'collecting': true});
                    }),
              )
            ],
          ),
        ));
  }
}
