import 'package:flutter/material.dart';
import 'dart:collection';

class LabelsModel with ChangeNotifier {
  final List<String> _labels = ["A", "B", "C", "D", "E"];

  late String _selectedLabel;

  UnmodifiableListView<String> get labels => UnmodifiableListView(_labels);

  String get selected {
    return this._selectedLabel;
  }

  set selected(final String label) {
    this._selectedLabel = label;
    this.notifyListeners();
  }

  void add(String newLabel) {
    _labels.add(newLabel);

    notifyListeners();
  }
}
