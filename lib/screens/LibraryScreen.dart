import 'dart:io';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gesture_collection_app/models/gesture_model.dart';
import 'package:gesture_collection_app/screens/Login_screen.dart';
import 'package:gesture_collection_app/services/GestureAudioLinkService.dart';
import 'package:gesture_collection_app/services/gesture_service.dart';
import 'package:gesture_collection_app/services/shared_preferences_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo {
  final String title;
  final String description;
  Todo(this.title, this.description);
}

class LibraryScreen extends StatefulWidget {
  static const String routeName = "/library";

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Todo todo;

  var backRouteName = "/speechcollect";

  // final List<String> items;
  final items = List<String>.generate(10000, (i) => "Item $i");

  late SharedPreferences prefs;

  String? userId = '';
  bool alertBox = false;

  // void onTapped(Post post) {
  var retrievedTitle;

  var newLabel = "";

  var newAudioText = "";

  // final todos = List<Todo>.generate(
  @override
  Widget build(BuildContext context) {
    // FirebaseStorage storage = FirebaseStorage(
    //     app: FirebaseFirestore.instance.app,
    //     storageBucket: 'gs://gesturedata-76273.appspot.com');
    // print("Daaata");
    // // storage.
    // print(storage.ref());
    //final Map args = ModalRoute.of(context).settings.arguments;
    //this.backRouteName = args["nextLink"];
    getUserId();
    Map args = (ModalRoute.of(context)!.settings.arguments??{}) as Map;

    if (args != null) {
      var showDialog = args["showDialog"];
      if (showDialog == "yes") {
        Fluttertoast.showToast(
            msg: "Gesture Data has been saved",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    }

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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
              SharedPreferences preferences = await SharedPreferences.getInstance();
              await preferences.remove('userId');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Login_screen(null)));
            },
            heroTag: 'btn1',
            child: Icon(Icons.logout),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              showAddLabelDialog(context);
            },
            heroTag: 'btn2',
            child: Icon(Icons.add_circle_outlined),
          ),
        ],
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
    var gestureList = [];
    snapshot.forEach((eachGesture) {
      Map<String, dynamic> prop = eachGesture.data() as Map<String, dynamic>;
      if (prop['userId'] == userId) {
        listOfGestures.add(eachGesture);
      }
      gestureList.add(eachGesture.data());
    });
    SharedPreferencesService.saveGestureList(gestureList);
    return listOfGestures;
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {

    var theme = Theme.of(context);
    var gestureModel = GestureModel.fromJson(data.data() as Map<String, dynamic>);
    return Padding(
      // key: ValueKey(record.location),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: GestureDetector(
        onLongPress: () {
          showEditLabelDialog(context, data);
        },
        onTap: () {
          GestureAudioLinkService.speak_from_text(gestureModel.audio);
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

  Future getImage() async {
    // Get image from gallery.
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // FilePickerResult result = await FilePicker.platform.pickFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path as String);
      print("image");
      // print(file);
      // File image = File('assets/audio/hello.mp3');
      // _uploadImageToFirebase(file);
    } else {
      // User canceled the picker
    }
    // var image = await FilePicker.getFile(type: FileType.audio);
    // final file =  await ImagePicker.pickVideo(source: ImageSource.gallery);
    // File file = await FilePicker.getFile();
    // File image = File('assets/audio/hello.mp3');
  }

  Future<void> _uploadImageToFirebase(File image) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = 'images/image${randomNumber}.mp3';

      // Upload image to firebase.
      final storageReference =
      FirebaseStorage.instance.ref().child(imageLocation);
      final firebase_storage.UploadTask uploadTask = storageReference.putFile(
          image, SettableMetadata(contentType: 'audio/mp3'));
      print(uploadTask);
      _addPathToDatabase(imageLocation);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addPathToDatabase(String text) async {
    try {
      // Get image URL from firebase
      final ref = FirebaseStorage.instance.ref().child(text);
      var imageString = await ref.getDownloadURL();

      // Add location and url to database
      await FirebaseFirestore.instance
          .collection('storage')
          .doc()
          .set({'url': imageString, 'location': text});
    } catch (e) {
      print(e);
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         content: Text(e.message),
      //       );
      //     }
      // );
    }
  }

  /*Future<void> uploadNewLabel(BuildContext context) async {
    Navigator.pop(context);
    if(newLabel.length == 0 || newAudioText.length == 0){
      return;
    }
    await FirebaseFirestore.instance.collection("gestureLibrary")
        .doc(newLabel)
        .set({
      'userId': userId,
      'url': '',
      'audio': newAudioText,
      'description':'',
      'location': ''
    }).then((value) {
      Fluttertoast.showToast(
          msg: newLabel + " label added.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
      newLabel = "";
      newAudioText = "";
    }
   );

  }*/
  Future<void> getUserId() async {
    prefs = await SharedPreferences.getInstance();
    String? _userId = prefs.getString("userId");
    userId = _userId;
  }

  void showEditLabelDialog(BuildContext context, DocumentSnapshot data) {
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
        title: "Edit Gesture Label",
        style: alertStyle,
        content: Column(
          children: <Widget>[
            Text('Edit gesture "${data.id}"',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.gesture),
                  labelText: 'Enter a Gesture here',
                ),
                onChanged: (text) {
                  newLabel = text;
                }),
            Padding(padding: EdgeInsets.all(5.0)),
            TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.audiotrack),
                    labelText: 'Enter a Gesture\'s audible response',
                    hintText: 'E.g How are you?'),
                onChanged: (text) {
                  newAudioText = text;
                }),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => editGestureLabel(context, data),
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ]).show();
  }


  void showAddLabelDialog(BuildContext context) {
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
        title: "Add new Gesture Label",
        style: alertStyle,
        content: Column(
          children: <Widget>[
            TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.gesture),
                  labelText: 'Enter a Gesture here',
                ),
                onChanged: (text) {
                  newLabel = text;
                }),
            Padding(padding: EdgeInsets.all(5.0)),
            TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.audiotrack),
                    labelText: 'Enter a Gesture\'s audible response',
                    hintText: 'E.g How are you?'),
                onChanged: (text) {
                  newAudioText = text;
                }),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => createGestureLabel(context),
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ]).show();
  }

  void editGestureLabel(BuildContext context, DocumentSnapshot data) {
    Navigator.pop(context);
    GestureService.uploadEditedLabel(userId, data['name'], newLabel, newAudioText).then((value) {
      if (value) {
        Fluttertoast.showToast(
            msg: newLabel + " label edited.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        newLabel = "";
        newAudioText = "";
      }
    });
    Navigator.of(context).pushNamed("/recordgesture",
        arguments: {'collecting': true, 'data': newLabel});
  }

  void createGestureLabel(BuildContext context) {
    Navigator.pop(context);
    GestureService.uploadNewLabel(userId, newLabel, newAudioText).then((value) {
      if (value) {
        Fluttertoast.showToast(
            msg: newLabel + " label added.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        newLabel = "";
        newAudioText = "";
      }
    });
    Navigator.of(context).pushNamed("/recordgesture",
        arguments: {'collecting': true, 'data': newLabel});
  }
}
// class Record {
//   final String location;
//   final String url;
//   final DocumentReference reference;
//
//   Record.fromMap(Map<String, dynamic> map, {this.reference})
//       : assert(map['location'] != null),
//         assert(map['url'] != null),
//         location = map['location'],
//         url = map['url'];
//
//   Record.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data, reference: snapshot.reference);
//
//   @override
//   String toString() => "Record<$location:$url>";
// }