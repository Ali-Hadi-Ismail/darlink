import 'package:darlink/constants/colors/colors_template.dart';
import 'package:darlink/constants/colors/template/blue_template.dart';
import 'package:darlink/constants/colors/template/dark_template.dart';
import 'package:darlink/constants/colors/template/green_template.dart';
import 'package:darlink/constants/colors/template/redBlack_template.dart';

class ThemeTemplateManager {
  static final _templates = {
    'green': GreenTemplate(),
    'redBlack': RedBlackTemplate(),
    'blue': BlueTemplate(),
    'dark': DarkTemplate(),
  };

  static String _currentTheme = "green";

  // No longer need initialize method since Cubit will handle it
  // Remove the initialize method

  static ColorTemplate get currentTemplate => _templates[_currentTheme]!;

  static void setTheme(String themeName) {
    if (_templates.containsKey(themeName)) {
      _currentTheme = themeName;
    }
  }

  static List<String> get availableThemes => _templates.keys.toList();

  static ColorTemplate getTemplate(String name) {
    return _templates[name] ?? _templates['green']!;
  }

  static void addTemplate(String name, ColorTemplate template) {
    _templates[name] = template;
  }
}
