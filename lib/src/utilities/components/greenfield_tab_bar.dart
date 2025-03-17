import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/notice/notice_view_model.dart';
import '../../viewmodels/post/post_view_model.dart';
import '../../viewmodels/recruit/recruit_view_model.dart';
import '../design_system/app_texts.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

class GreenFieldTabBar extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const GreenFieldTabBar({
    super.key, required this.navigationShell,
  });

  @override
  ConsumerState<GreenFieldTabBar> createState() => _GreenFieldTabBarState();
}

class _GreenFieldTabBarState extends ConsumerState<GreenFieldTabBar> {
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
                  color: widget.navigationShell.currentIndex == 0
                      ? Theme.of(context).appColors.gfMainColor
                      : Colors.grey,
                ),
                Text(
                  '홈',
                  style: AppTextsTheme.main().gfBody5.copyWith(
                    color: widget.navigationShell.currentIndex == 0
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
                color: widget.navigationShell.currentIndex == 1
                    ? Theme.of(context).appColors.gfMainColor
                    : Colors.grey,
              ),
              Text(
                '모집',
                style: AppTextsTheme.main().gfBody5.copyWith(
                  color: widget.navigationShell.currentIndex == 1
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
                color: widget.navigationShell.currentIndex == 2
                    ? Theme.of(context).appColors.gfMainColor
                    : Colors.grey,
              ),
              Text(
                '게시판',
                style: AppTextsTheme.main().gfBody5.copyWith(
                  color: widget.navigationShell.currentIndex == 2
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
                color: widget.navigationShell.currentIndex == 3
                    ? Theme.of(context).appColors.gfMainColor
                    : Colors.grey,
              ),
              Text('캠퍼스',
                  style: AppTextsTheme.main().gfBody5.copyWith(
                    color: widget.navigationShell.currentIndex == 3
                        ? Theme.of(context).appColors.gfMainColor
                        : Colors.grey,
                  )),
            ],
          ),
        ),
      ],
      currentIndex: widget.navigationShell.currentIndex,
      onTap: (index) async {
        if (index == 0) {
          final result = await ref.read(noticeViewModelProvider.notifier).getNoticeList();
        } else if (index == 1) {
          final result = await ref.read(recruitViewModelProvider.notifier).getRecruitList();
        }
        widget.navigationShell.goBranch(
          index,
          initialLocation: index == widget.navigationShell.currentIndex,
        );
      },
    );
  }
}
