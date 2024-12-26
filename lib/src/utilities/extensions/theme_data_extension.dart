import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_texts.dart';


extension ThemeDataExtended on ThemeData {
  AppColorsTheme get appColors => extension<AppColorsTheme>()!;
  AppTextsTheme get appTexts => extension<AppTextsTheme>()!;
}