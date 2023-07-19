import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gesture_collection_app/screens/LibraryScreen.dart';
import 'package:gesture_collection_app/screens/SpeechScreen.dart';
import 'package:gesture_collection_app/screens/library_home.dart';
import 'package:gesture_collection_app/screens/record_gesture_screen.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = "/dashboard";
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _screens = [RecordGestureScreen(), LibraryHome()];
  var _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        children: _screens,
        index: _selectedIndex,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            selectedItemColor: themeData.colorScheme.secondary,
            onTap: (newIndex) => setState(() => _selectedIndex = newIndex),
            currentIndex: _selectedIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/bottom_nav_speak.svg',
                  width: 25,
                  color: _selectedIndex == 0
                      ? themeData.colorScheme.secondary
                      : Colors.black,
                ),
                label: 'Speak',
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/bottom_nav_folder.svg',
                    width: 25,
                    color: _selectedIndex == 1
                        ? themeData.colorScheme.secondary
                        : Colors.black,
                  ),
                  label: 'Library')
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
