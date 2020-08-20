import 'package:flutter/foundation.dart';
import '../common/optionsData.dart';

class WordOptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _type = OptionsData.typeList[0];
  String _length = OptionsData.lengthList[1];

  String get type => _type;
  String get length => _length;

  void changeType({
    @required String type,
  }) {
    _type = type;
    notifyListeners();
  }

  void changeNumber({
    @required String length,
  }) {
    _length = length;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('type', type));
    properties.add(StringProperty('length', length));
  }
}
