import 'package:flutter/material.dart';

class AppTextsTheme extends ThemeExtension<AppTextsTheme> {
  static const _baseFamily = "Pretendard";

  final TextStyle gfHeading1;
  final TextStyle gfHeading2;
  final TextStyle gfHeading3;
  final TextStyle gfTitle1;
  final TextStyle gfTitle2;
  final TextStyle gfTitle3;
  final TextStyle gfTitle4;
  final TextStyle gfTitle5;
  final TextStyle gfBody1;
  final TextStyle gfBody2;
  final TextStyle gfBody3;
  final TextStyle gfBody4;
  final TextStyle gfBody5;
  final TextStyle gfCaption1;
  final TextStyle gfCaption2;
  final TextStyle gfCaption3;
  final TextStyle gfCaption4;
  final TextStyle gfCaption5;

  const AppTextsTheme._internal({
    required this.gfHeading1,
    required this.gfHeading2,
    required this.gfHeading3,
    required this.gfTitle1,
    required this.gfTitle2,
    required this.gfTitle3,
    required this.gfTitle4,
    required this.gfTitle5,
    required this.gfBody1,
    required this.gfBody2,
    required this.gfBody3,
    required this.gfBody4,
    required this.gfBody5,
    required this.gfCaption1,
    required this.gfCaption2,
    required this.gfCaption3,
    required this.gfCaption4,
    required this.gfCaption5,
  });

  factory AppTextsTheme.main() => const AppTextsTheme._internal(
    gfHeading1: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.bold,
      fontSize: 22,
      height: 23 / 22,
    ),
    gfHeading2: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      height: 22 / 16,
    ),
    gfHeading3: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14.4,
      height: 15 / 14.4,
    ),
    gfTitle1: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 22 / 18,
    ),
    gfTitle2: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 22 / 16,
    ),
    gfTitle3: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 20 / 14,
    ),
    gfTitle4: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w300,
      fontSize: 13,
      height: 22 / 13,
    ),
    gfTitle5: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.bold,
      fontSize: 12,
      height: 12 / 12,
    ),
    gfBody1: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w500,
      fontSize: 18,
      height: 24 / 18,
    ),
    gfBody2: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      height: 22 / 16,
    ),
    gfBody3: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 16 / 14,
    ),
    gfBody4: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 17 / 12,
    ),
    gfBody5: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w500,
      fontSize: 11,
      height: 16 / 11,
    ),
    gfCaption1: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w600,
      fontSize: 13,
      height: 18 / 13,
    ),
    gfCaption2: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w400,
      fontSize: 12.6,
      height: 15 / 12.6,
    ),
    gfCaption3: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w500,
      fontSize: 8,
      height: 11 / 8,
    ),
    gfCaption4: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.w500,
      fontSize: 8,
      height: 9.5 / 8,
    ),
    gfCaption5: TextStyle(
      fontFamily: _baseFamily,
      fontWeight: FontWeight.bold,
      fontSize: 7,
      height: 9 / 7,
    ),
  );

  @override
  ThemeExtension<AppTextsTheme> copyWith() {
    return AppTextsTheme._internal(
      gfHeading1: gfHeading1,
      gfHeading2: gfHeading2,
      gfHeading3: gfHeading3,
      gfTitle1: gfTitle1,
      gfTitle2: gfTitle2,
      gfTitle3: gfTitle3,
      gfTitle4: gfTitle4,
      gfTitle5: gfTitle5,
      gfBody1: gfBody1,
      gfBody2: gfBody2,
      gfBody3: gfBody3,
      gfBody4: gfBody4,
      gfBody5: gfBody5,
      gfCaption1: gfCaption1,
      gfCaption2: gfCaption2,
      gfCaption3: gfCaption3,
      gfCaption4: gfCaption4,
      gfCaption5: gfCaption5,
    );
  }

  @override
  ThemeExtension<AppTextsTheme> lerp(
    covariant ThemeExtension<AppTextsTheme>? other,
    double t) => this;
}
