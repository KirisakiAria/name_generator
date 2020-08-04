import 'package:flutter/foundation.dart';
import '../common/optionsData.dart';

class WordOptions with ChangeNotifier, DiagnosticableTreeMixin {
  String _type = OptionsData.typeList[0];
  String _number = OptionsData.numberList[1];

  String get type => _type;
  String get number => _number;

  void changeType({
    @required String type,
  }) {
    _type = type;
    notifyListeners();
  }

  void changeNumber({
    @required String number,
  }) {
    _number = number;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('type', type));
    properties.add(StringProperty('number', number));
  }
}
