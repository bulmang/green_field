import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/cores/router/router.dart';
import 'package:green_field/src/utilities/design_system/app_icons.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/notice/notice_edit_view_model.dart';
import 'package:green_field/src/viewmodels/notice/notice_view_model.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import '../../model/notice.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_content_widget.dart';
import '../../utilities/components/greenfield_user_info_widget.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/feature_type.dart';
import '../../utilities/enums/user_type.dart';

class NoticeDetailView extends ConsumerStatefulWidget {
  final Notice notice;

  const NoticeDetailView({super.key, required this.notice});

  @override
  _NoticeDetailViewState createState() => _NoticeDetailViewState();
}

class _NoticeDetailViewState extends ConsumerState<NoticeDetailView> {
  @override
  Widget build(BuildContext context) {
    final notice = widget.notice;
    final userState = ref.watch(onboardingViewModelProvider);
    final noticeNotifier = ref.watch(noticeViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: "공지사항",
        actions: [
          if (noticeNotifier.checkAuth(userState.value?.userType ?? ''))
            CupertinoButton(
                child: ImageIcon(
                  AssetImage(AppIcons.menu),
                  size: 24,
                  color: Theme.of(context).appColors.gfGray400Color,
                ),
                onPressed: () {
                  _showCupertinoActionSheet(
                    context,
                    notice, // 현재 공지사항 객체
                    ref.read(noticeEditViewModelProvider.notifier),
                    ref.read(noticeViewModelProvider.notifier),
                  );
                })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GreenfieldUserInfoWidget(
                featureType: FeatureType.notice,
                campus: notice.userCampus,
                createTimeText:
                    '${notice.createdAt.year}-${notice.createdAt.month}-${notice.createdAt.day}',
              ),
            ),
            GreenFieldContentWidget(
              title: notice.title,
              bodyText: notice.body,
              imageAssets: notice.images != null && notice.images!.isNotEmpty
                  ? notice.images!
                  : [],
              likes: notice.like.length,
              commentCount: 0,
            ),
          ],
        ),
      ),
    );
  }
}

void _showCupertinoActionSheet(
  BuildContext context,
  Notice notice,
  NoticeEditViewModel noticEditState,
  NoticeViewModel noticeState,
) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              '글 수정',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                    color: Theme.of(context).appColors.gfBlueColor,
                  ),
            ),
            onPressed: () {
              context.go('/home/notice/edit/modify/${notice.id}');
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              '글 삭제',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                    color: Theme.of(context).appColors.gfWarningColor,
                  ),
            ),
            onPressed: () async {
              final result = await noticEditState.deleteNoticeModel(notice.id);

              switch (result) {
                case Success():
                  noticeState.getNoticeList();
                  Navigator.pop(context);
                  context.go('/home/notice');
                case Failure(exception: final e):
                  noticEditState.flutterToast(e.toString());
              }
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('취소',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                    color: Theme.of(context).appColors.gfBlueColor,
                  )),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context); // Close the action sheet
          },
        ),
      );
    },
  );
}
