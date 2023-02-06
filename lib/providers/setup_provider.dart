import 'package:flutter/material.dart';

class SetupScreenProviderA extends ChangeNotifier {
  bool _isSetupScreenShown = false;
  bool get isSetupScreenShown => _isSetupScreenShown;

  void showSetupScreen() {
    _isSetupScreenShown = true;
    notifyListeners();
  }

  void hideSetupScreen() {
    _isSetupScreenShown = false;
    notifyListeners();
  }
}