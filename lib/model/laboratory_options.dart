import 'package:flutter/foundation.dart';

class LaboratoryOptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _romaji = false;

  bool get romaji => _romaji;

  void toggleRomaji() {
    _romaji = !romaji;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('romaji', romaji.toString()));
  }
}
