import 'package:flutter/foundation.dart';
import '../common/optionsData.dart';

class NameOptions with ChangeNotifier, DiagnosticableTreeMixin {
  String _type = OptionsData.typeList[0];
  String _number = OptionsData.numberList[0];

  String get type => _type;
  String get number => _number;

  void changeOptions({String type, String number}) {
    _type = type;
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
