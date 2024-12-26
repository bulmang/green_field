import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../design_system/app_texts.dart';

class GreenFieldAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgGroundColor;
  final String title;
  final Widget? leadingIcon;
  final Function()? leadingAction;
  final bool? noLeadingIcon;
  final List<Widget>? actions;

  const GreenFieldAppBar({
    super.key,
    required this.backgGroundColor,
    required this.title,
    this.actions,
    this.leadingIcon,
    this.leadingAction,
    this.noLeadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leading;
    if (leadingAction != null || leadingIcon != null) {
      leading = CupertinoButton(child: leadingIcon ?? Icon(Icons.arrow_left),
          onPressed: leadingAction);
    } else {
      leading = CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            size: 24,
            CupertinoIcons.back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        );
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppBar(
        backgroundColor: backgGroundColor,
        elevation: 0,
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(
            color: backgGroundColor,
          ),
        ),
        leading: leading,
        title: Text(
          title,
          style: AppTextsTheme.main().gfHeading2.copyWith(
              color: Theme.of(context).appColors.gfBlackColor
          ),
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // 기본 툴바 높이
}
