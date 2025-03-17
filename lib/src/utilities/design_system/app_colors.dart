import 'package:flutter/material.dart';

class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  final Color gfMainColor; // 02542D
  final Color gfMainBackGroundColor; // 02542D with 10% opacity
  final Color gfWarningBackGroundColor; // FF6A69 with 10% opacity
  final Color gfWarningYellowColor; // FFC35A
  final Color gfWarningYellowBackGroundColor; // FFC35A with 10% opacity
  final Color gfWarningColor; // FF6A69
  final Color gfBlueColor; // 007AFF
  final Color gfBlueBackGroundColor; // 007AFF
  final Color gfWhiteColor; // FBFDFD
  final Color gfBackGroundColor; // F4F4F9
  final Color gfGray100Color; // F3F4F6
  final Color gfGray300Color; // DBDEE2
  final Color gfGray400Color; // 8B95A1
  final Color gfGray800Color; // 535961
  final Color gfBlackColor; // 000000

  // Private constructor
  const AppColorsTheme._internal({
    required this.gfMainColor,
    required this.gfMainBackGroundColor,
    required this.gfWarningBackGroundColor,
    required this.gfWarningYellowColor,
    required this.gfWarningYellowBackGroundColor,
    required this.gfWarningColor,
    required this.gfBlueColor,
    required this.gfBlueBackGroundColor,
    required this.gfWhiteColor,
    required this.gfBackGroundColor,
    required this.gfGray100Color,
    required this.gfGray300Color,
    required this.gfGray400Color,
    required this.gfGray800Color,
    required this.gfBlackColor,
  });

  factory AppColorsTheme.main() {
    return const AppColorsTheme._internal(
      gfMainColor: const Color(0xFF02542D),
      gfMainBackGroundColor: const Color(0xFFE2EAE8),
      gfWarningBackGroundColor: const Color(0xFFFBECEE),
      gfWarningYellowColor: const Color(0xFFFFC35A),
      gfWarningYellowBackGroundColor: const Color(0xFFFBF2E4),
      gfWarningColor: const Color(0xFFFF6A69),
      gfBlueColor: const Color(0xFF007AFF),
      gfBlueBackGroundColor: const Color(0xFFE5F2FF),
      gfWhiteColor: const Color(0xFFFBFBFD),
      gfBackGroundColor: const Color(0xFFF4F4F9),
      gfGray100Color: const Color(0xFFF3F4F6),
      gfGray300Color: const Color(0xFFDBDEE2),
      gfGray400Color: const Color(0xFF8B95A1),
      gfGray800Color: const Color(0xFF535961),
      gfBlackColor: const Color(0xFF000000),
    );
  }

  @override
  AppColorsTheme copyWith() {
    return AppColorsTheme.main();
  }

  @override
  AppColorsTheme lerp(covariant ThemeExtension<AppColorsTheme>? other, double t) => this;
}
