import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_texts.dart';

class GreenFieldAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgGroundColor;
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const GreenFieldAppBar({
    super.key,
    required this.backgGroundColor,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppBar(
        backgroundColor: backgGroundColor,
        elevation: 0,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(
            color: Color(0XFFF4F4F4),
          ),
        ),
        leading: leading,
        title: Text(
          title,
          style: AppTextsTheme.main().gfHeading2.copyWith(
              color: AppColorsTheme().gfBlackColor
          ),
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // 기본 툴바 높이
}
