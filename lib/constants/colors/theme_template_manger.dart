import 'package:darlink/constants/colors/colors_template.dart';
import 'package:darlink/constants/colors/template/blue_template.dart';
import 'package:darlink/constants/colors/template/dark_template.dart';
import 'package:darlink/constants/colors/template/green_template.dart';
import 'package:darlink/constants/colors/template/redBlack_template.dart';

class AppThemeManager {
  static final _templates = {
    'green': GreenTemplate(),
    'redBlack': RedBlackTemplate(),
    'blue': BlueTemplate(),
    'dark': DarkTemplate(),
  };

  static String _currentTheme = "green"; // Default theme

  // Initialize with cubit
  static void initialize(dynamic cubit) async {
    _currentTheme = cubit.currentColor; // Set default theme from cubit
  }

  // Get current template
  static ColorTemplate get currentTemplate => _templates[_currentTheme]!;

  // Set current theme by name
  static void setTheme(String themeName) {
    if (_templates.containsKey(themeName)) {
      _currentTheme = themeName;
      // Add notification mechanism if needed
    }
  }

  // Get available theme names
  static List<String> get availableThemes => _templates.keys.toList();

  // Get template by name
  static ColorTemplate getTemplate(String name) {
    return _templates[name] ?? _templates['redBlack']!;
  }

  // Add a new template
  static void addTemplate(String name, ColorTemplate template) {
    _templates[name] = template;
  }
}
