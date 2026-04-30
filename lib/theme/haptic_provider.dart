import 'package:flutter/material.dart';

class HapticProvider extends ChangeNotifier {
  bool _enabled = true;

  bool get enabled => _enabled;

  void toggle(bool value) {
    _enabled = value;
    notifyListeners();
  }
}