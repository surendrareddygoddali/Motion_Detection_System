import 'package:flutter/material.dart';
import 'package:gesture_collection_app/screens/record_gesture_screen.dart';

class RecordGestureWidget extends StatelessWidget {
  static const String _appName = 'Gesture Collection';

  void _navigateToNextScreen(BuildContext context) {
    // Navigator.of(context)
    //   .pushNamed('/recordgesture', arguments: {'nextLink': '/collect'});
    Navigator.of(context)
        .pushNamed('/library');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain, // otherwise the logo will be tiny
              child: const FlutterLogo(),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 75,
                  child: FloatingActionButton.extended(
                    heroTag: 'next2',
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                    onPressed: () {
                      _navigateToNextScreen(context);
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      size: 48.0,
                    ),
                    label: Text(
                      'Start Recording',
                      style: new TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
