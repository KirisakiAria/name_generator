import 'package:flutter/foundation.dart';

class LaboratoryOptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _romaji = false; //罗马注音

  bool get romaji => _romaji;

  void clearAllSetting() {
    _romaji = false;
  }

  void toggleRomaji({bool romaji}) {
    if (romaji == null) {
      _romaji = !_romaji;
    } else {
      _romaji = romaji;
    }
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('romaji', romaji.toString()));
  }
}
