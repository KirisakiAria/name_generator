import 'package:flutter/foundation.dart';
import '../common/optionsData.dart';

class WordOptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _type = OptionsData.typeList[0];
  String _length = OptionsData.lengthList[1];
  bool _couples = false;

  String get type => _type;
  String get length => _length;
  bool get couples => _couples;

  void changeType(String type) {
    _type = type;
    notifyListeners();
  }

  void changeNumber(String length) {
    _length = length;
    notifyListeners();
  }

  void changeCouples(bool couples) {
    _couples = couples;
    notifyListeners();
  }
}
