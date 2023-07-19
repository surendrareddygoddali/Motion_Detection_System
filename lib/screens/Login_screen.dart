import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gesture_collection_app/screens/create_account.dart';
import 'package:gesture_collection_app/services/gesture_service.dart';
import 'package:gesture_collection_app/services/shared_preferences_service.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class Login_screen extends StatefulWidget {
  static const String routeName = "/login";
  Function? callback;
  Login_screen(this.callback);
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Login_screen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();

  late User? user;
  late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
                RoundedLoadingButton(
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                  controller: _btnController,
                  color: theme.colorScheme.secondary,
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                    login().then((value) {
                      if (value) {
                        loginSuccess();
                      } else {
                        print("login failed");
                        _btnController.reset();
                      }
                    });
                  },
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text('Don\'t have an account?'),
                      TextButton(
                        child: Text(
                          'Sign Up',
                          style:
                          TextStyle(fontSize: 20, color: theme.colorScheme.secondary),
                        ),
                        onPressed: () {
                          //signup screen
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => CreateAccount()));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ],
            )));
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return '';
    }
  }

  Future<bool> login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: nameController.text, password: passwordController.text);
      print("login success");
      user = userCredential.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", user!.uid);
      return Future<bool>.value(true);
    } on FirebaseAuthException catch (e) {
      print("login failed");
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      if (widget.callback != null) {
        widget.callback!();
      }
      return Future<bool>.value(false);
    }
  }

  void loginSuccess() {
    print("logged In");

    GestureService.getGesturesList()
        .then((value) => {navigateToHomeScreen(value)});
  }

  void navigateToHomeScreen(List<QueryDocumentSnapshot> value) {
    var allGesutures = [];
    value.forEach((QueryDocumentSnapshot snapshot) =>
    {allGesutures.add(snapshot.data())});
    SharedPreferencesService.saveGestureList(allGesutures);
    _btnController.success();
    if (widget.callback != null) {
      widget.callback!();
    }
  }

  _sendEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'biomed.ai.lab@gmail.com',
      query:
      'subject=Please allow me to signup&body=Please create my account on the Gesture App', //add subject and body here
    );

    String url = params.toString();
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch $url';
    }
  }
}
