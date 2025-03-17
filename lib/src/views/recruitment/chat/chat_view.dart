import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/chat/chat_view_model.dart';
import 'package:green_field/src/views/campus/camus_floor_section.dart';
import 'package:green_field/src/views/campus/camus_map_section.dart';
import 'package:green_field/src/views/campus/campus_operating_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../cores/error_handler/result.dart';
import '../../../model/recruit.dart';
import '../../../utilities/components/greenfield_app_bar.dart';
import '../../../utilities/components/greenfield_text_field.dart';
import '../../../utilities/design_system/app_icons.dart';
import '../../../utilities/design_system/app_texts.dart';
import '../../../utilities/enums/feature_type.dart';
import '../../../viewmodels/campus/campus_view_model.dart';
import '../../../viewmodels/onboarding/onboarding_view_model.dart';
import '../../../viewmodels/post/post_view_model.dart';
import '../../../viewmodels/recruit/recruit_edit_view_model.dart';
import '../../../viewmodels/recruit/recruit_view_model.dart';
import 'my_chat_bubble_widget.dart';
import 'other_chat_bubble_widget.dart';

class ChatView extends ConsumerStatefulWidget {
  final String? recruitId;
  const ChatView({super.key, this.recruitId});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final recruitState = ref.watch(recruitViewModelProvider);
    final recruitNotifier = ref.watch(recruitViewModelProvider.notifier);
    final recruitEditNotifier = ref.watch(recruitEditViewModelProvider.notifier);
    final currentRecruit = recruitState.value!.firstWhere((recruit) => recruit.id == widget.recruitId, orElse: () => recruitNotifier.exampleRecruit);
    final chatState = ref.watch(chatViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: '${DateTime.now().difference(currentRecruit.remainTime).inMinutes.abs()}분 후 채팅방이 사라집니다.',
        isChatView: true,
        isChatViewTimeLimit: (DateTime.now().difference(currentRecruit.remainTime).inMinutes.abs() >= 30),
        actions: [
          CupertinoButton(
            child: Icon(CupertinoIcons.ellipsis,color: Theme.of(context).appColors.gfGray400Color),
            onPressed: () {
              _showCupertinoActionSheet(
                context,
                currentRecruit,
                ref.read(recruitEditViewModelProvider.notifier),
                ref.read(recruitViewModelProvider.notifier),
                userState.value?.id ?? ''
              );
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: ref.watch(chatViewModelProvider.notifier).getMessageListStream(currentRecruit.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('에러 발생');
                  }

                  if (!snapshot.hasData) {
                    return Text('데이터 로딩 중...');
                  }

                  final messages = snapshot.data!;

                  if (messages.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    });
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      // 이전 메시지의 사용자 이름을 얻기 위해 index를 사용합니다.
                      final isPreviousSameUser = index > 0
                          ? messages[index - 1].userName == message.userName
                          : false;

                      // 메시지를 표시하는 위젯을 반환합니다.
                      return (message.userId == userState.value?.id)
                          ? MyChatBubbleWidget(
                        text: message.text,
                        time: message.createdAt,
                      )
                          : OtherChatBubbleWidget(
                        text: message.text,
                        time: message.createdAt,
                        creatorName: (message.userId == currentRecruit.creatorId) ? '글쓴이(작성자)' : message.userName,
                        isPreviousSameUser: isPreviousSameUser,
                      );
                    },
                  )
                  ;
                },
              ),
            ),

            GreenFieldTextField(
              type: FeatureType.recruit,
              onAction: (String text) async {
                final result = await ref
                    .read(chatViewModelProvider.notifier)
                    .createMessage(
                    currentRecruit,
                    userState.value!,
                    '익명${(currentRecruit.currentParticipants.indexOf(userState.value?.id ?? '') + 1)}(${userState.value?.campus}캠퍼스)',
                    text);

                switch(result) {
                  case Success(value: final v):
                    print('fff');
                  case Failure(exception: final e):
                    recruitEditNotifier.flutterToast('에러가 발생했습니다.');
                }
              },
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

void _showCupertinoActionSheet(
    BuildContext context,
    Recruit recruit,
    RecruitEditViewModel recruitEditState,
    RecruitViewModel recruitState,
    String userId,
    ) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              '신고하기',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                color: Theme.of(context).appColors.gfWarningColor,
              ),
            ),
            onPressed: () async {
              _showReportPicker(context, (String selectedReason) async {
                final result = await recruitState.reportRecruit(recruit.id, userId, selectedReason);

                switch (result) {
                  case Success(value: final v):
                    Navigator.pop(context);
                    recruitEditState.flutterToast('신고가 정상적으로 접수되었습니다.\n운영팀이 확인 후 조치할 예정입니다.');
                  case Failure(exception: final e):
                    recruitEditState.flutterToast('에러가 발생했어요!');
                }
              });
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              recruit.creatorId == userId ? '채팅방 삭제 및 나가기' : '나가기',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                color: Theme.of(context).appColors.gfWarningColor,
              ),
            ),
            onPressed: () async {
              if (recruit.creatorId == userId) {
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
              } else {
                final result = await recruitState.outChatRoom(
                    recruit.id, userId);

                switch (result) {
                  case Success():
                    Navigator.pop(context);
                    context.go('/recruit');
                  case Failure(exception: final e):
                    recruitEditState.flutterToast('에러가 발생했습니다.');
                }
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