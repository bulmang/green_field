import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/extensions/theme_data_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../design_system/app_colors.dart';
import '../../../design_system/app_icons.dart';
import '../../../design_system/app_texts.dart';

class ExternalLinkSection extends StatelessWidget {

  const ExternalLinkSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          iconText(AppIcons.sesac, '새싹 홈', () {
            _launchURL('https://sesac.seoul.kr/');
          }),
          iconText(AppIcons.restaurant, '식당 안내', () {
            _launchURL('https://sesac.seoul.kr/');
          }),
          iconText(AppIcons.file, '강의 자료', () {
            _launchURL('https://sesac.seoul.kr/');
          }),
          iconText(AppIcons.discord, '디스코드', () {
            _launchURL('https://sesac.seoul.kr/');
          }),
        ],
      ),
    );
  }
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Widget iconText(String imagePath, String label, VoidCallback onPressed) {
  return CupertinoButton(
    padding: EdgeInsets.zero, // Remove default padding
    onPressed: onPressed,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 40,
          height: 40,
        ),
        SizedBox(height: 4), // Space between image and text
        Text(
          label,
          style: AppTextsTheme.main().gfCaption2.copyWith(
            color: AppColorsTheme.main().gfBlackColor,
          ),
        ),
      ],
    ),
  );
}
