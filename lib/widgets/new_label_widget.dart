import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesture_collection_app/screens/record_gesture_screen.dart';
import 'package:gesture_collection_app/screens/tab_screen.dart';
import 'package:gesture_collection_app/widgets/label_widget.dart';

class NewLabelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 75,
                  child: FloatingActionButton.extended(
                    heroTag: 'next1',
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    onPressed: () => _asyncInputDialog(context),
                    icon: Icon(Icons.add, size: 48.0),
                    label: Text(
                      'Add a New Label',
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

_asyncInputDialog(BuildContext context) async {
  String gestureName = '';

  return showDialog(
    context: context,
    barrierDismissible:
    false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('New Label'),
        content: new Row(
          children: [
            new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Label', hintText: 'Enter gesture label'),
                  onChanged: (value) {
                    gestureName = value;
                  },
                ))
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop(gestureName);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabScreen(
                      gestureName,
                    ),
                  ));
              //LabelWidget(newLabel: gestureName);
            },
          ),
        ],
      );
    },
  );
}
