import 'package:flutter/material.dart';
import 'package:green_field/src/design_system/app_colors.dart';
import 'package:green_field/src/design_system/app_icons.dart';
import 'package:green_field/src/design_system/app_texts.dart';

class GreenfieldUserInfoWidget extends StatelessWidget {
  final String type; // 타입 (notice, post)
  final String campus;
  final String createTimeText;

  const GreenfieldUserInfoWidget({
    super.key,
    required this.type,
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
              type == 'notice' ? AppIcons.sesac : AppIcons.profile,
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
                    type == 'notice' ? campus :'익명($campus)',
                    style: AppTextsTheme.main().gfHeading3.copyWith(
                      color: type == 'notice' ? AppColorsTheme().gfMainColor : AppColorsTheme().gfGray800Color,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    createTimeText,
                    style: AppTextsTheme.main().gfBody5.copyWith(
                      color: AppColorsTheme().gfGray400Color,
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
