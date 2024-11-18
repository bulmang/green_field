import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/design_system/app_texts.dart';

import '../design_system/app_colors.dart';

class GreenFieldTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const GreenFieldTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

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
                  color: selectedIndex == 0
                      ? AppColorsTheme().gfMainColor
                      : Colors.grey,
                ),
                Text(
                  '홈',
                  style: AppTextsTheme.main().gfBody5.copyWith(
                    color: selectedIndex == 0
                        ? AppColorsTheme().gfMainColor
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
                color: selectedIndex == 1
                    ? AppColorsTheme().gfMainColor
                    : Colors.grey,
              ),
              Text(
                '모집',
                style: AppTextsTheme.main().gfBody5.copyWith(
                  color: selectedIndex == 1
                      ? AppColorsTheme().gfMainColor
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
                color: selectedIndex == 2
                    ? AppColorsTheme().gfMainColor
                    : Colors.grey,
              ),
              Text(
                '게시판',
                style: AppTextsTheme.main().gfBody5.copyWith(
                      color: selectedIndex == 2
                          ? AppColorsTheme().gfMainColor
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
                color: selectedIndex == 3
                    ? AppColorsTheme().gfMainColor
                    : Colors.grey,
              ),
              Text('캠퍼스',
                  style: AppTextsTheme.main().gfBody5.copyWith(
                        color: selectedIndex == 3
                            ? AppColorsTheme().gfMainColor
                            : Colors.grey,
                      )),
            ],
          ),
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
