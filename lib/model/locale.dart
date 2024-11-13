import 'package:flutter/material.dart';

class LocaleModel extends ChangeNotifier {
  Locale english = const Locale("en");
  Locale spanish = const Locale("es");

  Locale? _locale;
  
  LocaleModel() {
    _locale = english;
  }

  Locale? get locale => _locale;

  void set(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void swap() {
    if (_locale == english) {
      set(spanish);
    } else {
      set(english);
    }
  }
}