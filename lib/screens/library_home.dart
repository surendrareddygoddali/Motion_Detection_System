import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gesture_collection_app/screens/AvailableGestureList.dart';
import 'package:gesture_collection_app/screens/LibraryScreen.dart';
import 'package:gesture_collection_app/screens/Login_screen.dart';
import 'package:gesture_collection_app/screens/SpeechScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryHome extends StatefulWidget {
  static const String routeName = "/dashboard";
  const LibraryHome({Key? key}) : super(key: key);

  @override
  State<LibraryHome> createState() => _LibraryHomeState();
}

class _LibraryHomeState extends State<LibraryHome> {
  var isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    IFLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                    labelColor: theme.colorScheme.secondary,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(
                        text: 'Default Gestures',
                      ),
                      Tab(
                        text: 'My Gestures',
                      ),
                    ],
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: [
                AvailableGestureList(),
                !isLoggedIn ? Login_screen(afterLogin) : LibraryScreen(),
              ],
            ),
        ),
    );
  }

  Future<void> afterLogin() async {
    await IFLoggedIn();
  }

  Future<bool> IFLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    print(userId);
    if (userId == null || userId == '') {
      setState(() {
        this.isLoggedIn = false;
      });
      return false;
    } else {
      setState(() {
        this.isLoggedIn = true;
      });
      return true;
    }
  }
}
