import 'package:flutter/material.dart';

import 'services/emission_calculator.dart';

class AppState extends ChangeNotifier {
  Locale _locale = const Locale('en');
  double _electricityFactor = EmissionFactors.defaultElectricityKgCo2PerKwh;

  Locale get locale => _locale;
  double get electricityFactor => _electricityFactor;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void setElectricityFactor(double value) {
    _electricityFactor = value;
    notifyListeners();
  }
}
