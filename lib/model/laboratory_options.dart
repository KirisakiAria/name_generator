import 'package:flutter/foundation.dart';

class LaboratoryOptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _romaji = false; //罗马注音

  bool get romaji => _romaji;

  void clearAllSetting() {
    _romaji = false;
  }

  void toggleRomaji({bool romaji}) {
    _romaji = romaji ?? !_romaji;
    notifyListeners();
  }
}
