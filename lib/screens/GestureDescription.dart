import 'package:flutter/material.dart';
import 'package:gesture_collection_app/main.dart';
import 'package:gesture_collection_app/models/labels.dart';
import 'package:gesture_collection_app/screens/record_gesture_screen.dart';
import 'package:gesture_collection_app/services/gesture_service.dart';
import 'package:gesture_collection_app/services/shared_preferences_service.dart';
import 'package:gesture_collection_app/widgets/label_widget.dart';
import 'package:gesture_collection_app/widgets/new_label_widget.dart';
import 'package:gesture_collection_app/widgets/record_gesture_widget.dart';
import 'package:gesture_collection_app/widgets/top_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LibraryScreen.dart';

class GestureDescription extends StatefulWidget {
  static const String routeName = "/GestureDescription";
  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<GestureDescription> {
//class _HomeScreenState extends StatelessWidget {
  static const String routeName = "/GestureDescription";
  TextEditingController gestureTextController = TextEditingController();
  String title = "";
  bool _hideAllViewsExceptAudibleText = false;
  String videoURL = "";
  String gestureText = "";
  //HomeScreen({Key key, @required this.newLabel}) : super(key: key);
  _HomeScreenState() {}
  bool _isVideoButtonVisible = true;
  bool _isRecordButtonVisible = false;
  void hideVideoButton() {
    setState(() {
      _isVideoButtonVisible = !_isVideoButtonVisible;
    });
  }

  void hideRecordButton() {
    setState(() {
      _isRecordButtonVisible = !_isRecordButtonVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map args =
    ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    this._hideAllViewsExceptAudibleText = args["availableGestureList"];
    if (_hideAllViewsExceptAudibleText != null) {
      hideVideoButton();
      hideRecordButton();
    } else {
      this.videoURL = args["videoURL"];

      if (videoURL.length == 0) {
        hideVideoButton();
      }
    }
    this.title = args["data"];
    this.gestureText = args["audioText"];
    gestureTextController.text = gestureText;
    SharedPreferencesService.getCustomGestureText(title).then((value) => {
      if (value != null) {updateGestureText(value)}
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("",
              style: new TextStyle(
                fontSize: 20.0,
              )),
          Padding(padding: EdgeInsets.all(10.0)),
          Padding(padding: EdgeInsets.all(10.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Visibility(
                    visible: _isVideoButtonVisible,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.grey[300],
                            backgroundColor: Colors.green,
                            minimumSize: Size(300, 75)),
                        child: Text("View Video",
                            style: new TextStyle(
                              fontSize: 20.0,
                            )),
                        onPressed: () {
                          if (videoURL.length == 0) {
                            return;
                          }
                          _launchURL(videoURL);
                        })),
              )
            ],
          ),
          Padding(padding: EdgeInsets.all(25.0)),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: gestureTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gesture\'s audible response',
              ),
              onChanged: (text) {
                SharedPreferencesService.saveCustomGestureText(title, text);
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(50.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Visibility(
                    visible: !_isRecordButtonVisible,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.grey[300],
                            backgroundColor: Colors.blue,
                            minimumSize: Size(300, 75)),
                        child: Text("Record Gesture",
                            style: new TextStyle(
                              fontSize: 20.0,
                            )),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/recordgesture',
                              arguments: {'nextLink': '/library', 'data': title});
                        }),
                  ))
            ],
          ),
        ]),
      ),
    );
  }

  updateGestureText(String value) {
    gestureText = value;
    gestureTextController.text = value;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
