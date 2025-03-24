import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/viewmodels/chat/chat_view_model.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:green_field/src/viewmodels/recruit/recruit_edit_view_model.dart';
import 'package:green_field/src/viewmodels/recruit/recruit_view_model.dart';
import '../../cores/error_handler/result.dart';
import '../../model/recruit.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_user_info_widget.dart';
import '../../utilities/components/greenfield_content_widget.dart';
import '../../utilities/components/greenfield_confirm_button.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/feature_type.dart';
import '../../utilities/extensions/theme_data_extension.dart';

class RecruitDetailView extends ConsumerStatefulWidget {
  final String recruitId; // Recruit object to display details

  const RecruitDetailView({super.key, required this.recruitId});

  @override
  _RecruitDetailViewState createState() => _RecruitDetailViewState();
}

class _RecruitDetailViewState extends ConsumerState<RecruitDetailView> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final recruitState = ref.watch(recruitViewModelProvider);
    final recruitNotifier = ref.watch(recruitViewModelProvider.notifier);
    final recruitEditNotifier = ref.watch(recruitEditViewModelProvider.notifier);
    final currentRecruit = recruitState.value!.firstWhere((recruit) => recruit.id == widget.recruitId, orElse: () => Recruit(id: 'id', creatorId: 'creatorId', remainTime: DateTime.now(), currentParticipants: [], maxParticipants: 1, creatorCampus: 'creatorCampus', isEntryAvailable: false, title: '오류', body: '오류발생', createdAt: DateTime.now()));

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: "모집",
        leadingIcon: Icon(
          CupertinoIcons.xmark,
          color: Theme.of(context).appColors.gfGray400Color,
        ),
        leadingAction: () {
          context.pop();
        },
        actions: [
          (recruitNotifier.checkAuth(userState.value?.userType, userState.value?.id ?? '', currentRecruit.creatorId ?? ''))
              ? CupertinoButton(
            child: Icon(CupertinoIcons.ellipsis,color: Theme.of(context).appColors.gfGray400Color),
            onPressed: () {
              _showCupertinoActionSheet(
                context,
                currentRecruit,
                ref.read(recruitEditViewModelProvider.notifier),
                ref.read(recruitViewModelProvider.notifier),
              );
            },
          )
              : CupertinoButton(
            child: Icon(CupertinoIcons.exclamationmark_shield,color: Theme.of(context).appColors.gfGray400Color),
            onPressed: () {
              _showIOSDialog(
                context: context,
                title: '이 모집글을 신고하시겠어요?',
                body: '신고 사유를 정확히 선택해주세요. 잘못된 신고는 처리가 어려울 수 있어요.',
                onConfirm: () async {
                  _showReportPicker(context, (String selectedReason) async {
                    final result = await ref
                        .read(recruitViewModelProvider.notifier)
                        .reportRecruit(currentRecruit.id ?? '', userState.value?.id ?? '', selectedReason);

                    switch (result) {
                      case Success(value: final v):
                        recruitEditNotifier.flutterToast('신고가 정상적으로 접수되었습니다.\n운영팀이 확인 후 조치할 예정입니다.');
                      case Failure(exception: final e):
                        recruitEditNotifier.flutterToast('에러가 발생했어요!');
                    }
                  });
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GreenfieldUserInfoWidget(
                        featureType: FeatureType.recruit,
                        campus: currentRecruit.creatorCampus,
                        createTimeText: '${currentRecruit.createdAt.year}-${currentRecruit.createdAt.month}-${currentRecruit.createdAt.day}',
                      ),
                    ),
                    GreenFieldContentWidget(
                      featureType: FeatureType.recruit,
                      title: currentRecruit.title,
                      bodyText: currentRecruit.body,
                      imageAssets: currentRecruit.images != null && currentRecruit.images!.isNotEmpty ? currentRecruit.images! : [],
                      recruit: currentRecruit,
                      commentCount: 0,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: GreenFieldConfirmButton(
                text: recruitNotifier.isEntryChatRoomActive(currentRecruit.currentParticipants.length, currentRecruit.maxParticipants)
                    ? "채팅으로 이야기 해보기"
                    : "채팅방 입장 불가",
                isAble: true,
                textColor: recruitNotifier.isEntryChatRoomActive(currentRecruit.currentParticipants.length, currentRecruit.maxParticipants)
                    ? Theme.of(context).appColors.gfMainColor
                    : Theme.of(context).appColors.gfWarningColor,
                backGroundColor: recruitNotifier.isEntryChatRoomActive(currentRecruit.currentParticipants.length, currentRecruit.maxParticipants)
                    ? Theme.of(context).appColors.gfMainBackGroundColor
                    : Theme.of(context).appColors.gfWarningBackGroundColor,
                onPressed: () async {
                  if (recruitNotifier.isEntryChatRoomActive(currentRecruit.currentParticipants.length, currentRecruit.maxParticipants)) {
                    final getRecruitList = await ref.read(recruitViewModelProvider.notifier).getRecruitList();

                    switch (getRecruitList) {
                      case Success():
                        final getRecruitResult = await ref.read(recruitViewModelProvider.notifier).getRecruit(currentRecruit.id);

                        switch (getRecruitResult) {
                          case Success(value: final recruit):
                            if (DateTime.now().isBefore(recruit.remainTime)) {
                              if (recruitNotifier.isEntryChatRoomActive(recruit.currentParticipants.length, recruit.maxParticipants)) {
                                final entryResult = await ref.read(
                                    recruitViewModelProvider.notifier)
                                    .entryChatRoom(currentRecruit.id,
                                    userState.value?.id ?? '');

                                switch (entryResult) {
                                  case Success():
                                    context.go('/recruit/chat/${recruit.id}');
                                  case Failure(exception: final e):
                                    recruitEditNotifier.flutterToast(
                                        '에러가 발생했어요!');
                                }
                              } else if (currentRecruit.currentParticipants.contains(userState.value?.id ?? '')) {
                                context.go('/recruit/chat/${currentRecruit.id}');
                              }
                              else {
                                recruitEditNotifier.flutterToast('채팅방에 인원이 모두 찼어요.');
                              }
                            } else {
                              context.go('/recruit');
                              recruitEditNotifier.flutterToast('시간이 지난 채팅방이에요');
                            }

                          case Failure(exception: final e):
                            context.go('/recruit');
                            recruitEditNotifier.flutterToast('시간이 지난 채팅방이에요');
                        }

                      case Failure(exception: final e):
                        recruitEditNotifier.flutterToast('에러가 발생했어요!');
                    }
                  } else {
                    recruitEditNotifier.flutterToast('채팅방에 인원이 모두 찼어요.');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showIOSDialog({
  required BuildContext context,
  required String title,
  required String body,
  required VoidCallback onConfirm,
}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        CupertinoDialogAction(
          child: Text("취소", style: TextStyle(color: CupertinoColors.activeBlue),),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text("확인", style: TextStyle(color: CupertinoColors.systemRed),),
          onPressed: () {
            Navigator.pop(context); // 먼저 다이얼로그 닫기
            onConfirm(); // 콜백 실행
          },
        ),
      ],
    ),
  );
}

void _showCupertinoActionSheet(
    BuildContext context,
    Recruit recruit,
    RecruitEditViewModel recruitEditState,
    RecruitViewModel recruitState,
    ) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: Text('모집글은 수정할 수 없습니다.'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              '글 삭제',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                color: Theme.of(context).appColors.gfWarningColor,
              ),
            ),
            onPressed: () async {
              final result = await recruitEditState.deleteRecruitModel(recruit.id);

              switch (result) {
                case Success():
                  context.go('/recruit');
                  final updateResult = await recruitState.deleteRecruitInList(recruit.id);

                  switch (updateResult) {
                    case Success():
                      Navigator.pop(context);
                    case Failure(exception: final e):
                      recruitEditState.flutterToast('에러발생');
                  }
                case Failure(exception: final e):
                  recruitEditState.flutterToast(e.toString());
              }
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context); // Close the action sheet
          },
          child: Text('취소',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                color: Theme.of(context).appColors.gfBlueColor,
              )),
        ),
      );

    },
  );
}

void _showReportPicker(BuildContext context, Function(String) onConfirm)  {
  int _selectedReasonIndex = 0;
  const List<String> _reportReasons = [
    '불법촬영물등의 유통',
    '음란물/불건전한 만남 및 대화',
    '유출/사칭/사기',
    '게시판 성격에 부적절함',
    '욕설/비하',
    '정당/정치인 비하 및 선거운동',
    '상업적 광고 및 판매',
    '낚시/놀람/도배',
  ];

  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.2,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(initialItem: _selectedReasonIndex),
                  onSelectedItemChanged: (int index) {
                    _selectedReasonIndex = index;
                  },
                  children: _reportReasons.map((reason) => Center(child: Text(reason))).toList(),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('확인', style: TextStyle(fontSize: 18, color: CupertinoColors.systemRed)),
                onPressed: () {
                  Navigator.pop(context); // Picker 닫기
                  onConfirm(_reportReasons[_selectedReasonIndex]); // 신고 사유 전달
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}