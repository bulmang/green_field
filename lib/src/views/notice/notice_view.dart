import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/components/greenfield_loading_widget.dart';
import 'package:green_field/src/utilities/design_system/app_icons.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_list.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

import '../../utilities/design_system/app_texts.dart';
import '../../viewmodels/notice/notice_view_model.dart';
import '../../viewmodels/onboarding/onboarding_view_model.dart';

class NoticeView extends ConsumerStatefulWidget {
  const NoticeView({super.key});

  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends ConsumerState<NoticeView> {
  final noticeVM = NoticeViewModel();

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final noticeState = ref.watch(noticeViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: "공지사항",
        actions: [
          if (userState.value?.userType != 'student')
            CupertinoButton(
                child: Icon(
                  CupertinoIcons.square_pencil,
                  size: 24,
                  color: Theme.of(context).appColors.gfGray400Color,
                ),
                onPressed: () {
                  context.go('/home/notice/edit');
                })
        ],
      ),
      body: (noticeState.value!.isNotEmpty)
          ? RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: noticeState.value!.length,
                itemBuilder: (context, index) {
                  final notice = noticeState.value![index];
                  return GreenFieldList(
                    title: notice.title,
                    content: notice.body,
                    date: '${notice.createdAt.year}-${notice.createdAt.month}-${notice.createdAt.day}',
                    campus: notice.userCampus,
                    imageUrl: notice.images != null && notice.images!.isNotEmpty
                        ? notice.images![0]
                        : "",
                    likes: notice.like.length,
                    commentCount: 0,
                    onTap: () {
                      context.go('/home/notice/detail/${notice.id}');
                    },
                  );
                },
              ),
            )
          : Center(
              child: Column(
                children: [
                  Text(
                    '${userState.value!.campus ?? ''}캠퍼스의 공지사항이 없습니다.\n',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextsTheme.main().gfTitle1.copyWith(
                          color: Theme.of(context).appColors.gfBlackColor,
                        ),
                  ),
                  Text(
                    '${userState.value!.campus ?? ''}캠퍼스 관리자님께 문의 부탁드립니다.',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextsTheme.main().gfTitle2.copyWith(
                          color: Theme.of(context).appColors.gfBlackColor,
                        ),
                  ),
                  Spacer(),
                  Image.asset(
                    AppIcons.notebookSesac,
                    width: 240,
                    height: 240,
                  )
                ],
              ),
            ),
    );
  }
}
