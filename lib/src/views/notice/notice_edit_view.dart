import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/cores/image_type/image_type.dart';
import 'package:green_field/src/utilities/components/greenfield_loading_widget.dart';
import 'package:green_field/src/viewmodels/notice/notice_edit_view_model.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import '../../model/notice.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_edit_section.dart';
import '../../utilities/enums/feature_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../viewmodels/notice/notice_view_model.dart';

class NoticeEditView extends ConsumerStatefulWidget {
  final Notice? notice;
  const NoticeEditView({super.key, this.notice});

  @override
  _NoticeEditViewState createState() => _NoticeEditViewState();
}

class _NoticeEditViewState extends ConsumerState<NoticeEditView> {
  ValueNotifier<bool> isCompleteActive = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final noticeEditState = ref.watch(noticeEditViewModelProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).appColors.gfWhiteColor,
          appBar: GreenFieldAppBar(
            backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
            title: "공지사항 작성",
            leadingIcon: Icon(
              CupertinoIcons.xmark,
              color: Theme.of(context).appColors.gfGray400Color,
            ),
            leadingAction: () {
              context.pop();
            },
            actions: [
              CupertinoButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  isCompleteActive.value = !isCompleteActive.value;
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF308F5B), Color(0xFF666666)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 30,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      '완료',
                      style: AppTextsTheme.main().gfCaption2.copyWith(
                            color: Theme.of(context).appColors.gfWhiteColor,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: GreenFieldEditSection(
            instanceModel: widget.notice,
            type: FeatureType.post,
            onSubmit:
                (String title, String body, List<ImageType> images) async {
              if(images.length > 8) {
                ref
                    .read(noticeEditViewModelProvider.notifier)
                    .flutterToast('사진은 최대 8장까지 업로드할 수 있어요.');
                return;
              }
              if (title != '' && body != '') {
                final result = await ref
                    .read(noticeEditViewModelProvider.notifier)
                    .createNoticeModel(
                        userState.value, title, body, images, widget.notice);

                switch (result) {
                  case Success(value: final value):
                    final getNotice = await ref
                        .read(noticeViewModelProvider.notifier)
                        .getNotice(widget.notice?.id ?? value.id);

                    switch (getNotice) {
                      case Success(value: final value):
                        if(widget.notice == null) {
                          final getNoticeList = await ref
                              .read(noticeViewModelProvider.notifier)
                              .getNoticeList();

                          switch (getNoticeList) {
                            case Success():
                              context.go('/home/notice/detail/${value.id}');
                            case Failure(exception: final e):
                              ref
                                  .read(noticeEditViewModelProvider.notifier)
                                  .flutterToast('공지사항 글을 가져오기 실패하였습니다.');
                          }
                        } else {
                          context.go('/home/notice/detail/${value.id}');
                        }

                      case Failure(exception: final e):
                        ref
                            .read(noticeEditViewModelProvider.notifier)
                            .flutterToast('공지사항 글을 가져오기 실패하였습니다.');
                    }

                  case Failure(exception: final e):
                    ref
                        .read(noticeEditViewModelProvider.notifier)
                        .flutterToast('공지사항 등록에 실패하였습니다.${e.toString()}');
                }
              } else {
                ref
                    .read(noticeEditViewModelProvider.notifier)
                    .flutterToast('제목과 내용을 입력해주세요.');
                isCompleteActive.value = !isCompleteActive.value;
              }
            },
            isCompleteActive: isCompleteActive,
          ),
        ),
        noticeEditState.isLoading
            ? GreenFieldLoadingWidget()
            : SizedBox.shrink()
      ],
    );
  }
}
