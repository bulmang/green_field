import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../design_system/app_texts.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

class GreenFieldTabBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const GreenFieldTabBar({
    super.key, required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.home,
                  size: 24,
                  color: navigationShell.currentIndex == 0
                      ? Theme.of(context).appColors.gfMainColor
                      : Colors.grey,
                ),
                Text(
                  '홈',
                  style: AppTextsTheme.main().gfBody5.copyWith(
                    color: navigationShell.currentIndex == 0
                        ? Theme.of(context).appColors.gfMainColor
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.person_2,
                size: 24,
                color: navigationShell.currentIndex == 1
                    ? Theme.of(context).appColors.gfMainColor
                    : Colors.grey,
              ),
              Text(
                '모집',
                style: AppTextsTheme.main().gfBody5.copyWith(
                  color: navigationShell.currentIndex == 1
                      ? Theme.of(context).appColors.gfMainColor
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.chat_bubble_text,
                size: 24,
                color: navigationShell.currentIndex == 2
                    ? Theme.of(context).appColors.gfMainColor
                    : Colors.grey,
              ),
              Text(
                '게시판',
                style: AppTextsTheme.main().gfBody5.copyWith(
                  color: navigationShell.currentIndex == 2
                      ? Theme.of(context).appColors.gfMainColor
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.info,
                size: 24,
                color: navigationShell.currentIndex == 3
                    ? Theme.of(context).appColors.gfMainColor
                    : Colors.grey,
              ),
              Text('캠퍼스',
                  style: AppTextsTheme.main().gfBody5.copyWith(
                    color: navigationShell.currentIndex == 3
                        ? Theme.of(context).appColors.gfMainColor
                        : Colors.grey,
                  )),
            ],
          ),
        ),
      ],
      currentIndex: navigationShell.currentIndex,
      onTap: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
    );
  }
}
