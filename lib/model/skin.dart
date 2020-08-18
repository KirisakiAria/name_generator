import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../common/style.dart';

class SkinProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ThemeData _theme = Style.defaultTheme;

  ThemeData get theme => _theme;

  void changeTheme({
    @required ThemeData theme,
  }) {
    _theme = theme;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('theme', theme.toString()));
  }
}
