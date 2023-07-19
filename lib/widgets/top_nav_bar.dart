import 'package:flutter/material.dart';

class TopNavBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final String backlink;
  final bool navEnabled;
  final String forwardLink;
  final bool actionEnabled;

  const TopNavBarWidget({
    Key? key,
    required this.height,
    required this.title,
    this.backlink = "",
    this.navEnabled = false,
    this.actionEnabled = false,
    this.forwardLink = "",
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  IconData getIcon(String pagename) {
    if (pagename == "main") {
      return Icons.ac_unit;
    } else {
      return Icons.accessibility;
    }
  }

  getLeading(BuildContext context, bool navEnabled) {
    if (navEnabled) {
      return BackButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.of(context).pushNamed(backlink);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = this.title.length.toDouble();
    print(fontSize);
    return Column(
      children: [
        Container(
          color: Colors.grey[300],
          child: AppBar(
            leading: getLeading(context, this.navEnabled),
            title: Center(
              child: Text(
                //_pages[_selectedPageIndex]['title'],
                this.title,
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 23),
                maxLines: 2,
              ),
            ),
            actions: getActions(actionEnabled, forwardLink, context),
          ),
        ),
      ],
    );
  }

  goBack(String backlink) {
    //TODO: Implement back navigation
  }

  getActions(bool actionEnabled, String forwardLink, BuildContext context) {
    if (actionEnabled) {
      IconButton button = IconButton(
          icon: Icon(getIcon("test"), color: Colors.blue, size: 36.0),
          onPressed: () {
            Navigator.of(context).pushNamed(forwardLink);
          });
      return [button];
    }
  }
}
