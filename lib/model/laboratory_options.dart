import 'package:flutter/foundation.dart';

class LaboratoryOptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool _romaji = false; //罗马注音
  bool _likeWord = true; //点赞网名

  bool get romaji => _romaji;
  bool get likeWord => _likeWord;

  void clearAllSetting() {
    _romaji = false;
    _likeWord = false;
  }

  void toggleRomaji({bool romaji}) {
    _romaji = romaji ?? !_romaji;
    notifyListeners();
  }

  void toggleLikeWord({bool likeWord}) {
    _likeWord = likeWord ?? !_likeWord;
    notifyListeners();
  }
}
