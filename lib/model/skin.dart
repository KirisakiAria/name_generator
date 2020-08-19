import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../common/style.dart';

class SkinProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ThemeData _theme = Style.themeList[0];
  Map<String, Color> _color = Style.colorList[0];

  ThemeData get theme => _theme;
  Map<String, Color> get color => _color;

  void changeTheme({
    @required ThemeData theme,
    @required Map<String, Color> color,
  }) {
    _theme = theme;
    _color = color;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('theme', theme.toString()));
    properties.add(StringProperty('color', color.toString()));
  }
}
