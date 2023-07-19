import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:gesture_collection_app/main.dart';
import 'package:gesture_collection_app/screens/gesture_screen.dart';
import 'package:gesture_collection_app/screens/home_screen.dart';
import 'package:gesture_collection_app/widgets/label_widget.dart';
import 'package:gesture_collection_app/widgets/new_label_widget_old.dart';
import 'package:gesture_collection_app/widgets/top_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
//import 'package:gesture_collection_app/models/TFLiteHelper.dart';

import 'LibraryScreen.dart';

class TabScreen extends StatefulWidget {
  static const String routeName = "/collect";
  String? newLabel;
  TabScreen(this.newLabel);

  @override
  //_TabScreenState createState() => _TabScreenState(newLabel: newLabel);
  _TabScreenState createState() => _TabScreenState(newLabel as String);
}

class _TabScreenState extends State<TabScreen> {
  //static const String _appName = 'Gesture Collection';
  /*final List<Widget> _pages = [
    LabelWidget(),
    GestureScreen(),
  ];*/
  //_TabScreenState({Key key, @required newLabel});
//_TabScreenState({Key key, @required this.newLabel});

  late String _newLabel;

  _TabScreenState(String newLabel) {
    _newLabel = newLabel;
  }

  String get newLabel => _newLabel;

  set newLabel(String newLabel) {
    //_newLabel = newLabel;
    setState(() {
      _newLabel = newLabel;
    });
  }

  @override
  void initState() {
    /*setState(() {
      _newLabel = newLabel;
    });*/
    createUser();
    print('Initialize TFLITE');

    super.initState();
  }

  SharedPreferences? prefs;

  getPage(String title) {
    final List<Map<String, Object>> _pages = [
      {
        'page': HomeScreen(newLabel: newLabel),
        'title': 'Gesture Collection',
      },
      {
        'page': GestureScreen(),
        'title': 'My Gestures',
      },
    ];
    return _pages[_selectedPageIndex][title];
  }

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        height: 300,
        backlink: "/loading",
        title: getPage('title'),
      ),
      //body: _pages[_selectedPageIndex]['page'],
      body: getPage('page'),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        //backgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.grey,
        unselectedItemColor: Colors.white,
        //selectedItemColor: Theme.of(context).accentColor,
        selectedItemColor: Colors.yellowAccent,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.bar_chart_sharp),
            label: 'My Gestures',
          ),
        ],
      ),
    );
  }

  Future<void> createUser() async {
    prefs = await SharedPreferences.getInstance();
    String? userId = prefs!.getString("userId");
    if (userId == null || userId == '') {
      var uuid = Uuid();
      prefs!.setString("userId", uuid.v1());
    }
  }
}
