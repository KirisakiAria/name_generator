//核心库
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//common
import '../common/style.dart';

class SkinProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _themeIndex = 0;
  ThemeData _theme = Style.themeList[0];
  Map<String, Color> _color = Style.colorList[0];

  int get themeIndex => _themeIndex;
  ThemeData get theme => _theme;
  Map<String, Color> get color => _color;

  void changeTheme({
    @required int themeIndex,
    @required ThemeData theme,
    @required Map<String, Color> color,
  }) {
    _themeIndex = themeIndex;
    _theme = theme;
    _color = color;
    notifyListeners();
  }
}
