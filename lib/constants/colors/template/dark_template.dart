// Dark template
import 'dart:ui';

import 'package:darlink/constants/colors/colors_template.dart';

class DarkTemplate implements ColorTemplate {
  @override
  Color get primary => Color(0xFF37375F);
  @override
  Color get primaryLight => Color(0xFF3C3A4F);
  @override
  Color get primaryDark => Color(0xFF292841);
  @override
  Color get secondary => Color(0xFF663434);
  @override
  Color get secondaryLight => Color(0xFF7A4747);
  @override
  Color get accent => Color(0xFFFFFFFF);
  @override
  Color get textPrimary => Color(0xFFFFFFFF);
  @override
  Color get textSecondary => Color(0xFFBBBBBB);
  @override
  Color get textOnPrimary => Color(0xFFFFFFFF);
  @override
  Color get textOnDark => Color(0xFFFFFFFF);
  @override
  Color get textOnLight => Color(0xFF000000);
  @override
  Color get background => Color(0xFF191919);
  @override
  Color get backgroundDark => Color(0xFF121212);
  @override
  Color get surface => Color(0xFF222222);
  @override
  Color get cardBackground => Color(0xFF3C3A4F);
  @override
  Color get cardDarkBackground => Color(0xFF663434);
  @override
  Color get divider => Color(0xFF444444);
  @override
  Color get dividerDark => Color(0xFF333333);
  @override
  Color get success => Color(0xFF4CAF50);
  @override
  Color get warning => Color(0xFFFFB300);
  @override
  Color get error => Color(0xFFE53935);
  @override
  Color get info => Color(0xFF2196F3);
  @override
  Color get disabled => Color(0xFF555555);
  @override
  Color get disabledDark => Color(0xFF444444);
}
