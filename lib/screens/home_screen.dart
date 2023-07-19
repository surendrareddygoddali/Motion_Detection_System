import 'package:flutter/material.dart';
import 'package:gesture_collection_app/main.dart';
import 'package:gesture_collection_app/models/labels.dart';
import 'package:gesture_collection_app/screens/record_gesture_screen.dart';
import 'package:gesture_collection_app/services/gesture_service.dart';
import 'package:gesture_collection_app/widgets/label_widget.dart';
import 'package:gesture_collection_app/widgets/new_label_widget.dart';
import 'package:gesture_collection_app/widgets/record_gesture_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  String? newLabel;
  HomeScreen({Key? key, this.newLabel}) : super(key: key);

  @override
  //_TabScreenState createState() => _TabScreenState(newLabel: newLabel);
  _HomeScreenState createState() => _HomeScreenState(newLabel);
}

class _HomeScreenState extends State<HomeScreen> {
//class _HomeScreenState extends StatelessWidget {
  late String _newLabel;
  //HomeScreen({Key key, @required this.newLabel}) : super(key: key);
  _HomeScreenState(newLabel) {
    _newLabel = newLabel;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LabelsModel>(
            create: (final BuildContext context) {
              return LabelsModel();
            },
          ),
        ],
        child: Scaffold(
          body: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  'assets/images/gestures.jpeg',
                  fit: BoxFit.cover,
                ),
                /*child: FittedBox(
              fit: BoxFit.contain, // otherwise the logo will be tiny
              //child: const FlutterLogo(),
              child: Image.asset(
                'assets/images/gestures.jpeg',
                fit: BoxFit.cover,
              ),
            ),*/
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          height: 75,
                          child: LabelWidget(
                            newLabel: _newLabel,
                          ))),
                ],
              ),
              SizedBox(height: 20),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: Container(height: 75, child: NewLabelWidget())),
                ],
              ),
              SizedBox(height: 20),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child:
                      Container(height: 75, child: RecordGestureWidget())),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}
