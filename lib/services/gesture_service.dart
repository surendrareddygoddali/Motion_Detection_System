import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gesture_collection_app/models/GestureData.dart';
import 'package:gesture_collection_app/models/gesture.dart';
// import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

// import '../main copy.dart';

class GestureService extends Service {
  static const url = 'https://gesturedata-76273.firebaseio.com/gestures.json';
  static const urlData =
      'https://gesturedata-76273.firebaseio.com/GestureData.json';
  List<Gesture> _gestures = [];

  Future<bool> addGesture(Gesture gesture) async {
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'userId': gesture.userId,
            'label': gesture.label,
            'xData': gesture.xData,
            'yData': gesture.yData,
            'zData': gesture.zData,
            'dateAdded': gesture.dateAdded
          }));
      print("-- Response API --");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Gesture>> getGestures() async {
    try {
      final response = await http.get(Uri.parse(url));
      print("=================================================\n\n");
      print(response);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Gesture> loadedGestures = [];
      print("Fetching gesture list");
      print(extractedData);
      extractedData.forEach((userId, gestureData) {
        print(gestureData);
        loadedGestures.add(Gesture(
          userId,
          gestureData['label'],
          gestureData['xData'],
          gestureData['yData'],
          gestureData['zData'],
          gestureData['dateAdded'],
        ));
      });
      return loadedGestures;
    } catch (error) {
      throw (error);
    }

    //id, label, xData, yData, zData, dateAdded
  }

  // Future<Gesture> detectGesture(List gestures) async {
  //   //TODO: Send accelerometer data to model

  //   return null;
  // }

  static Stream<QuerySnapshot> getGestureLibrarySnapShot() {
    return FirebaseFirestore.instance.collection('gestureLibrary').snapshots();
  }

  static Future<List<QueryDocumentSnapshot>> getGesturesList() async {
    var allSnapshot =
    await FirebaseFirestore.instance.collection('gestureLibrary').get();
    const collection = {};
    List<QueryDocumentSnapshot> snapshot = allSnapshot.docs;
    /*snapshot.forEach((QueryDocumentSnapshot doc) => {
    collection[doc.id] = doc.data();
    });*/
    return snapshot;
  }

  static Future<bool> uploadEditedLabel(userId, oldGesture, newGesture, audioText) async {
    if (newGesture.length == 0 || audioText.length == 0 || oldGesture.length == 0) {
      return false;
    }

    await FirebaseFirestore.instance
        .collection("gestureLibrary")
        .doc(newGesture)
        .set({
      'userId': userId,
      'name': newGesture,
      'url': '',
      'audio': audioText,
      'description': '',
      'location': ''
    }).then((value) async {
      print('New Gesture Added');
      await FirebaseFirestore.instance
          .collection("gestureLibrary").doc(oldGesture).delete()
          .then((value) {
            print('Old Gesture Deleted');
            return true;
          });
    });
    return false;
  }

  static Future<bool> updatedChangedAudioResponse(userId, gestureName, audioText) async {
    if (gestureName.length == 0 || audioText.length == 0) {
      return false;
    }
    await FirebaseFirestore.instance
        .collection("gestureLibrary")
        .doc(gestureName)
        .update({
      'audio': audioText,
    }).then((value) async {
      print('Audio Updated');
        return true;
    });
    return false;
  }

  static Future<bool> uploadNewLabel(userId, gesture, audioText) async {
    if (gesture.length == 0 || audioText.length == 0) {
      return false;
    }
    await FirebaseFirestore.instance
        .collection("gestureLibrary")
        .doc(gesture)
        .set({
      'userId': userId,
      'name': gesture,
      'url': '',
      'audio': audioText,
      'description': '',
      'location': ''
    }).then((value) {
      /*Fluttertoast.showToast(
          msg: newLabel + " label added.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
      newLabel = "";
      newAudioText = "";*/
      return true;
    });
    return false;
  }

  static Future<bool> uploadGestureData(
      String userId, String timestamp, GestureData gesture) async {
    await FirebaseFirestore.instance
        .collection("GestureData")
        .doc(userId + "_" + timestamp)
        .set({
      'userId': userId,
      'name': gesture.label,
      'data': gesture.data.toString(),
      'time': timestamp
    }).then((value) {
      /*Fluttertoast.showToast(
          msg: newLabel + " label added.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
      newLabel = "";
      newAudioText = "";*/
      return Future<bool>.value(true);
    });
    return false;
  }

/*Future<void> addProduct(Gesture gesture) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'userId': gesture.userId,
            'label': gesture.label,
            'xData': gesture.xData,
            'yData': gesture.yData,
            'zData': gesture.zData,
            'dateAdded': gesture.dateAdded
          }));
    } catch (e) {
      // TODO
    }
  }*/

/*Future<void> updateGesture(String id, Gesture gesture) async {
    final gestureIndex = _gestures.indexWhere((element) => element.id == id);
    final url = 'https://gesture-collection.firebaseio.com/gestures/$id.json';
    try {
      if (gestureIndex >= 0) {
        await http.patch(url,
            body: json.encode({
              'userId': gesture.userId,
              'label': gesture.label,
              'xData': gesture.xData,
              'yData': gesture.yData,
              'zData': gesture.zData,
              'dateAdded': gesture.dateAdded
            }));
      }
    } catch (e) {
      // TODO
    }
  }*/

/*void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }*/

/*Future<void> deleteGesture(String id) async {
    final gestureIndex = _gestures.indexWhere((element) => element.id == id);
    final url = 'https://gesture-collection.firebaseio.com/gestures/$id.json';
    var existingGesture = _gestures[gestureIndex];
    _gestures.removeAt(gestureIndex);
    try {
      http.delete(url).then((value) => existingGesture = null);
    } catch (e) {
      _gestures.insert(gestureIndex, existingGesture);
    }
    //notifyListeners();
  }*/

// final FirebaseStorage storage = FirebaseStorage(
//     app: FirebaseFirestore.instance.app,
//     storageBucket: 'gs://my-project.appspot.com');
//
// Uint8List imageBytes;
// String errorMsg;
//
// MyHomePageState() {
//   storage.ref().child('selfies/me2.jpg').getData(10000000).then((data) =>
//       setState(() {
//         imageBytes = data;
//       })
//   ).catchError((e) =>
//       setState(() {
//         errorMsg = e.error;
//       })
//   );
// }
//
// @override
// Widget build(BuildContext context) {
//   var img = imageBytes != null ? Image.memory(
//     imageBytes,
//     fit: BoxFit.cover,
//   ) : Text(errorMsg != null ? errorMsg : "Loading...");
//
//   return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: new ListView(
//         children: <Widget>[
//           img,
//         ],
//       ));
// }
}
