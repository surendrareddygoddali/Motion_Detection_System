import 'package:flutter/material.dart';

class NewLabelWidgetOld extends StatefulWidget {
  NewLabelWidgetOld({Key? key}) : super(key: key);

  @override
  _NewLabelWidgetState createState() => _NewLabelWidgetState();
}

class _NewLabelWidgetState extends State<NewLabelWidgetOld> {
  late TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
          controller: _controller,
          onSubmitted: (String value) async {
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Adding "$value".'),
                  content: Text('Click OK to add "$value".'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
