import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gesture_collection_app/models/labels.dart';

var selectedLabel;

class LabelWidget extends StatefulWidget {
  String? newLabel;
  LabelWidget({Key? key, this.newLabel}) : super(key: key);
  // String labelName = selectedLabel;

  @override
  _LabelWidgetState createState() => _LabelWidgetState();
}

class _LabelList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var labelNameStyle = Theme.of(context).textTheme.headline6;
    var labels = context.watch<LabelsModel>();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.done),
        title: Text(labels.labels[index]),
      ),
    );
  }
}

class _LabelWidgetState extends State<LabelWidget> {
  String dropdownValue = 'Select Label';
  late SharedPreferences prefs;
  // static const String LABELS = 'labels';
  // List<String> labels = new List<String>();
  var _isInit = true;

  late String _newLabel;

  @override
  void initState() {
    _isInit = false;
    //updatelabels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LabelsModel>(builder: (
        final BuildContext context,
        final LabelsModel labelsModel,
        final Widget? child,
        ) {
      return DropdownButton<String>(
        value: labelsModel.selected,
        onChanged: (final String? newValue) {
          labelsModel.selected = newValue as String;
        },
        items: labelsModel.labels
            .map<DropdownMenuItem<String>>((final String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: SizedBox(
              width: 350.0,
              child: Text(
                value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      );
    });
  }

/*


    return Scaffold(
      body: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.white, fontSize: 20),
          underline: Container(
            height: 2,
            color: Colors.white70,
          ),
          onChanged: (String labelValue) {
            setState(() {
              dropdownValue = labelValue;
              //_newLabel = newValue;
              selectedLabel = dropdownValue;
            });
          },
          isExpanded: true,
          items: labels.map<DropdownMenuItem<String>>((final String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                width: 350.0,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
// */
//   Future<void> readLabels() async {
//     prefs = await SharedPreferences.getInstance();
//     List<String> _labels = prefs.getStringList(LABELS);
//     setState(() {
//       if (!_labels
//           .map((e) => e.toLowerCase())
//           .contains(_newLabel.toLowerCase())) {
//         _labels.add(_newLabel);
//       }
//       labels = _labels.toSet().toList();
//       labels.sort((a, b) => a.length.compareTo(b.length));
//     });
//   }
//
//   Future<void> updatelabels() async {
//     prefs = await SharedPreferences.getInstance();
//     List<String> _labels = prefs.getStringList(LABELS);
//     if (_labels != null && _newLabel != null) {
//       if (!_labels
//           .map((e) => e.toLowerCase())
//           .contains(_newLabel.toLowerCase())) {
//         _labels.add(_newLabel);
//       }
//       //labels = _labels.toSet().toList();
//       //dropdownValue = _newLabel;
//       prefs.setStringList(LABELS, this.labels);
//     } else {}
//   }
}
