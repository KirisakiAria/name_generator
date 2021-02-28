import 'package:flutter/foundation.dart';
import '../common/word_options.dart';

class WordOptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  Map<String, dynamic> _type = WordOptions.typeList[0];
  Map<String, dynamic> _length = WordOptions.lengthList[1];
  Map<String, dynamic> _surname = WordOptions.surnameList[0];
  bool _randomCombinations = false;
  bool _couples = false;

  Map<String, dynamic> get type => _type;
  Map<String, dynamic> get length => _length;
  Map<String, dynamic> get surname => _surname;
  bool get randomCombinations => _randomCombinations;
  bool get couples => _couples;

  void changeType(Map<String, dynamic> type) {
    _type = type;
    notifyListeners();
  }

  void changeNumber(Map<String, dynamic> length) {
    _length = length;
    notifyListeners();
  }

  void changeSurname(Map<String, dynamic> surname) {
    _surname = surname;
    notifyListeners();
  }

  void toggleRandomCombinations(bool randomCombinations) {
    _randomCombinations = randomCombinations;
    notifyListeners();
  }

  void toggleCouples(bool couples) {
    _couples = couples;
    notifyListeners();
  }
}
