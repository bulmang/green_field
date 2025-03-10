import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_icons.dart';
import '../design_system/app_texts.dart';
import '../enums/feature_type.dart';

class GreenfieldUserInfoWidget extends StatelessWidget {
  final FeatureType featureType;
  final String campus;
  final String createTimeText;

  const GreenfieldUserInfoWidget({
    super.key,
    required this.featureType,
    required this.campus,
    required this.createTimeText,
  });

  @override
  Widget build(BuildContext context) {
    return _buildUserInfoWidget();
  }

  Widget _buildUserInfoWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 40,
        // Row 위젯
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              featureType == FeatureType.notice ? AppIcons.sesac : AppIcons.profile,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 8),
            // Column 위젯
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    featureType  == FeatureType.notice ? campus :'익명($campus캠퍼스)',
                    style: AppTextsTheme.main().gfHeading3.copyWith(
                      color: featureType  == FeatureType.notice ? AppColorsTheme.main().gfMainColor : AppColorsTheme.main().gfGray800Color,
                    ),
                  ),
                  Text(
                    createTimeText,
                    style: AppTextsTheme.main().gfBody5.copyWith(
                      color: AppColorsTheme.main().gfGray400Color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
