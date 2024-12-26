import 'package:flutter/material.dart';
import '../design_system/app_texts.dart';
import '../design_system/app_colors.dart';


extension ThemeDataExtended on ThemeData {
  AppColorsTheme get appColors => extension<AppColorsTheme>()!;
  AppTextsTheme get appTexts => extension<AppTextsTheme>()!;
}