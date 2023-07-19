import 'dart:io';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gesture_collection_app/models/gesture.dart';
import 'package:gesture_collection_app/models/gesture_model.dart';
import 'package:gesture_collection_app/screens/IndividualGestureScreen.dart';
import 'package:gesture_collection_app/services/GestureAudioLinkService.dart';
import 'package:gesture_collection_app/services/gesture_service.dart';
import 'package:gesture_collection_app/services/shared_preferences_service.dart';
import 'package:gesture_collection_app/widgets/top_nav_bar.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvailableGestureList extends StatelessWidget {
  static const String routeName = "/availableGestureList";
  var backRouteName = "/speech";

  var newAudioText = "";
  late SharedPreferences prefs;
  String? userId = '';

  @override
  Widget build(BuildContext context) {
    getUserId();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
              child: _buildBody(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: GestureService.getGestureLibrarySnapShot(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> listOfGestures = filterData(snapshot);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        // width / height: fixed for *all* items
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, i) => _buildListItem(context, listOfGestures[i]),
      padding: const EdgeInsets.only(top: 10.0),
      itemCount: listOfGestures.length,
    );
    // print(snapshot);
  }

  List<DocumentSnapshot> filterData(List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> listOfGestures = [];
    snapshot.forEach((eachGesture) {
      Map<String, dynamic> prop = eachGesture.data() as Map<String, dynamic>;
      if (prop["userId"] == "") {
        listOfGestures.add(eachGesture);
      }
    });

    return listOfGestures;
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    var theme = Theme.of(context);
    var gestureModel = GestureModel.fromJson(data.data() as Map<String, dynamic>);
    return Padding(
      // key: ValueKey(record.location),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: GestureDetector(
        onTap: () {
          GestureAudioLinkService.speak_from_text(gestureModel.audio);
        },
        onLongPress: () {
          changeAudioDialog(context, data.id);
        },
        child: DottedBorder(
          color: theme.colorScheme.secondary,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 10,),
                  Text(
                    data.id.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    //record.location,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    gestureModel.audio as String,
                    overflow: TextOverflow.ellipsis,
                    //record.location,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            // Image.network(record.url),
          ),
        ),
      ),
    );
  }

  void changeAudioDialog(BuildContext context, String gestureName) {
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromBottom,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        descStyle: TextStyle(color: Colors.white, fontSize: 16),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(color: Colors.white, fontSize: 18),
        constraints: BoxConstraints.expand(width: 300),
        //First to chars "55" represents transparency of color
        overlayColor: Color(0x70000000),
        alertElevation: 0,
        alertAlignment: Alignment.center);
    Alert(
        context: context,
        title: "Edit Audio Label",
        style: alertStyle,
        content: Column(
          children: <Widget>[
            Text('Edit Audio',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.audiotrack),
                    labelText: 'Enter an audio text',
                    hintText: 'E.g How are you?'),
                onChanged: (text) {
                  newAudioText = text;
                }),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              GestureService.updatedChangedAudioResponse(userId, gestureName, newAudioText);
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ]).show();
  }

  Future<void> getUserId() async {
    prefs = await SharedPreferences.getInstance();
    String? _userId = prefs.getString("userId");
    userId = _userId;
  }

}
