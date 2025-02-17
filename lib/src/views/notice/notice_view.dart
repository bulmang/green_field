import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/utilities/design_system/app_colors.dart';
import 'package:green_field/src/utilities/design_system/app_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_list.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/user_type.dart';
import '../../viewmodels/notice/notice_view_model.dart';
import '../../viewmodels/onboarding/onboarding_view_model.dart';

class NoticeView extends ConsumerStatefulWidget {
  const NoticeView({super.key});

  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends ConsumerState<NoticeView> {
  final controller = ScrollController();
  final noticeVM = NoticeViewModel();
  bool hasMore = true;
  bool loading = false;

  Future refresh() async {
    final noticeNotifier = ref.watch(noticeViewModelProvider.notifier);
    final result = await noticeNotifier.getNoticeList();

    switch (result) {
      case Success():
        hasMore = true;

      case Failure(exception: final e):
        noticeNotifier.showToast(
            '에러가 발생했어요! $e',
            ToastGravity.TOP,
            AppColorsTheme.main().gfWarningColor,
            AppColorsTheme.main().gfWhiteColor);
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if ((controller.position.maxScrollExtent * 0.8 <= controller.offset) && !loading) {
        setState(() {
          loading = true;
        });
        fetch();
      }
    });
  }

  Future fetch() async {
    final noticeNotifier = ref.watch(noticeViewModelProvider.notifier);
    final result = await noticeNotifier.getNextNoticeList();
    setState(() {
      switch (result) {
        case Success(value: final value):
          if (value.isEmpty) {
            hasMore = false;
          }
          loading = false;

        case Failure(exception: final e):
          loading = false;
          noticeNotifier.showToast(
              '에러가 발생했어요!',
              ToastGravity.BOTTOM,
              AppColorsTheme.main().gfWarningColor,
              AppColorsTheme.main().gfWhiteColor);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final noticeState = ref.watch(noticeViewModelProvider);
    final noticeNotifier = ref.watch(noticeViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: "공지사항",
        actions: [
          if (noticeNotifier.checkAuth(userState.value?.userType ?? ''))
            CupertinoButton(
              child: Icon(
                CupertinoIcons.square_pencil,
                size: 24,
                color: Theme.of(context).appColors.gfGray400Color,
              ),
              onPressed: () {
                context.go('/home/notice/edit');
              },
            )
        ],
      ),
      body: (noticeState.hasValue)
          ? RefreshIndicator(
              onRefresh: refresh,
              color: Theme.of(context).appColors.gfGray400Color, // 로딩 스피너의 색상
              backgroundColor: Colors.white, // 배경 색상
              strokeWidth: 2.0, // 로딩 스피너의 두께
              child: ListView.builder(
                controller: controller,
                itemCount: noticeState.value!.length + 1,
                itemBuilder: (context, index) {
                  if (index < noticeState.value!.length) {
                    final notice = noticeState.value![index];
                    return noticeState.isLoading
                        ? Skeletonizer.zone(
                            effect: ShimmerEffect(
                              baseColor: Theme.of(context)
                                  .appColors
                                  .gfMainBackGroundColor,
                              highlightColor:
                                  Theme.of(context).appColors.gfWhiteColor,
                              duration: const Duration(seconds: 2),
                            ),
                            child: Card(
                              shadowColor: Colors.transparent,
                              color: Theme.of(context).appColors.gfWhiteColor,
                              child: ListTile(
                                trailing: Bone.square(size: 40),
                                title: Bone.text(words: 2),
                                subtitle: Bone.text(),
                              ),
                            ),
                          )
                        : GreenFieldList(
                            title: notice.title,
                            content: notice.body,
                            date:
                                '${notice.createdAt.year}-${notice.createdAt.month}-${notice.createdAt.day}',
                            campus: notice.userCampus,
                            imageUrl: notice.images != null &&
                                    notice.images!.isNotEmpty
                                ? notice.images![0]
                                : "",
                            likes: notice.like.length,
                            commentCount: 0,
                            onTap: () {
                              context.go('/home/notice/detail/${notice.id}');
                            },
                          );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: hasMore
                          ? loading
                              ? Center(
                                  child: Transform.scale(
                                    scale: 5.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: Lottie.asset(
                                        height: 60,
                                        'assets/lotties/loading_list.json',
                                        repeat: true,
                                        animate: true,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Theme.of(context).appColors.gfWhiteColor,
                                  height: 60,
                                )
                          : GreenFieldList(
                              title: '해당 캠퍼스의 공지사항이 없습니다.',
                              content: '모든 공지사항을 보셨어요!',
                              date: '9999-01-17',
                              campus: '개발자 생일',
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/sesacGif.gif?alt=media',
                              likes: 999,
                              commentCount: 0,
                              last: true,
                              onTap: () {
                                noticeNotifier.showToast(
                                    '더 이상 공지사항은 없어요!',
                                    ToastGravity.BOTTOM,
                                    AppColorsTheme.main().gfWarningColor,
                                    AppColorsTheme.main().gfWhiteColor);
                              },
                            ),
                    );
                  }
                },
              ),
            )
          : Center(
              child: Column(
                children: [
                  Text(
                    '${userState.value?.campus ?? ''}캠퍼스의 공지사항이 없습니다.\n',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextsTheme.main().gfTitle1.copyWith(
                          color: Theme.of(context).appColors.gfBlackColor,
                        ),
                  ),
                  Text(
                    '${userState.value?.campus ?? ''}캠퍼스 관리자님께 문의 부탁드립니다.',
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
