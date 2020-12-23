import 'package:flutter/foundation.dart';
import '../common/wordOptions.dart';

class WordOptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _type = OptionsData.typeList[0]['value'];
  String _length = OptionsData.lengthList[1]['value'];
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
