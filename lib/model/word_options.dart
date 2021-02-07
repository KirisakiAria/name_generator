import 'package:flutter/foundation.dart';
import '../common/word_options.dart';

class WordOptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Map<String, dynamic> _type = WordOptions.typeList[0];
  Map<String, dynamic> _length = WordOptions.lengthList[1];
  bool _random = false;
  bool _couples = false;

  Map<String, dynamic> get type => _type;
  Map<String, dynamic> get length => _length;
  bool get random => _random;
  bool get couples => _couples;

  void changeType(Map<String, dynamic> type) {
    _type = type;
    notifyListeners();
  }

  void changeNumber(Map<String, dynamic> length) {
    _length = length;
    notifyListeners();
  }

  void toggleRandom(bool couples) {
    _couples = couples;
    notifyListeners();
  }

  void toggleCouples(bool couples) {
    _couples = couples;
    notifyListeners();
  }
}
