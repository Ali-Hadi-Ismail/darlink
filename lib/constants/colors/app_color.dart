import 'dart:ui';

import 'package:darlink/constants/colors/theme_template_manger.dart';

class AppColors {
  // Primary colors
  static Color get primary => AppThemeManager.currentTemplate.primary;
  static Color get primaryLight => AppThemeManager.currentTemplate.primaryLight;
  static Color get primaryDark => AppThemeManager.currentTemplate.primaryDark;

  // Secondary colors
  static Color get secondary => AppThemeManager.currentTemplate.secondary;
  static Color get secondaryLight =>
      AppThemeManager.currentTemplate.secondaryLight;
  static Color get accent => AppThemeManager.currentTemplate.accent;

  // Text colors
  static Color get textPrimary => AppThemeManager.currentTemplate.textPrimary;
  static Color get textSecondary =>
      AppThemeManager.currentTemplate.textSecondary;
  static Color get textOnPrimary =>
      AppThemeManager.currentTemplate.textOnPrimary;
  static Color get textOnDark => AppThemeManager.currentTemplate.textOnDark;
  static Color get textOnLight => AppThemeManager.currentTemplate.textOnLight;

  // Background colors
  static Color get background => AppThemeManager.currentTemplate.background;
  static Color get backgroundDark =>
      AppThemeManager.currentTemplate.backgroundDark;
  static Color get surface => AppThemeManager.currentTemplate.surface;

  // UI elements
  static Color get cardBackground =>
      AppThemeManager.currentTemplate.cardBackground;
  static Color get cardDarkBackground =>
      AppThemeManager.currentTemplate.cardDarkBackground;
  static Color get divider => AppThemeManager.currentTemplate.divider;
  static Color get dividerDark => AppThemeManager.currentTemplate.dividerDark;

  // Status colors
  static Color get success => AppThemeManager.currentTemplate.success;
  static Color get warning => AppThemeManager.currentTemplate.warning;
  static Color get error => AppThemeManager.currentTemplate.error;
  static Color get info => AppThemeManager.currentTemplate.info;

  // Disabled states
  static Color get disabled => AppThemeManager.currentTemplate.disabled;
  static Color get disabledDark => AppThemeManager.currentTemplate.disabledDark;
}
