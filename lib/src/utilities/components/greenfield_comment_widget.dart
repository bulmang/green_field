import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../../cores/error_handler/result.dart';
import '../../model/comment.dart';
import '../../model/post.dart';
import '../../viewmodels/onboarding/onboarding_view_model.dart';
import '../../viewmodels/post/post_detail_view_model.dart';
import '../../viewmodels/post/post_view_model.dart';
import '../design_system/app_icons.dart';
import '../design_system/app_texts.dart';

class GreenFieldCommentWidget extends ConsumerStatefulWidget {
  final String commetId;
  final String commentCreatId;
  final Post post;
  final String campus;
  final DateTime dateTime;
  final String commentText;

  const GreenFieldCommentWidget({
    super.key,
    required this.commetId,
    required this.campus,
    required this.dateTime,
    required this.commentText,
    required this.commentCreatId,
    required this.post,
  });

  @override
  _GreenFieldCommentWidgetState createState() => _GreenFieldCommentWidgetState();
}

class _GreenFieldCommentWidgetState extends ConsumerState<GreenFieldCommentWidget> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final postNotifier = ref.watch(postViewModelProvider.notifier);
    final postDetailState = ref.watch(postDetailViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          color: Theme.of(context).appColors.gfGray300Color,
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.only(left: 30, right: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(AppIcons.profile, width: 30, height: 30),
                  SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (widget.post.creatorId == widget.commentCreatId)
                              ? '작성자(${widget.campus}캠퍼스)'
                              : '익명${widget.post.commentId.indexOf(widget.commentCreatId) + 1}(${widget.campus}캠퍼스)',
                          style: AppTextsTheme.main().gfBody5.copyWith(
                            color: (widget.post.creatorId == widget.commentCreatId)
                                ? Theme.of(context).appColors.gfMainColor
                                : Theme.of(context).appColors.gfBlackColor,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${widget.dateTime.month}/${widget.dateTime.day} ${widget.dateTime.hour}:${widget.dateTime.minute.toString().padLeft(2, '0')}',
                          style: AppTextsTheme.main().gfCaption5.copyWith(
                            color: Theme.of(context).appColors.gfGray400Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  (userState.value!.id == widget.commentCreatId)
                      ? CupertinoButton(
                    child: Icon(
                      CupertinoIcons.delete,
                      size: 20,
                      color: Theme.of(context).appColors.gfGray400Color,
                    ),
                    onPressed: () {
                      _showIOSDialog(
                        context: context,
                        title: '이 댓글을 삭제하시겠어요?',
                        body: "한 번 삭제하면 복구할 수 없습니다.",
                        onConfirm: () async {
                            final result = await ref
                                .read(postDetailViewModelProvider.notifier)
                                .deleteCommentModel(widget.post.id, widget.commetId);

                            switch (result) {
                              case Success(value: final v):
                                final result = await ref
                                    .read(postViewModelProvider.notifier)
                                    .updateCommentCount(widget.post.id);

                                switch (result) {
                                  case Success(value: final v):
                                    print(v);
                                  case Failure(exception: final e):
                                    postNotifier.showToast('에러가 발생했어요!', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                                }

                              case Failure(exception: final e):
                                postNotifier.showToast('에러가 발생했어요!', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                            }
                        },
                      );
                    },
                  )
                      : CupertinoButton(
                    child: Text(
                      '신고',
                      style: AppTextsTheme.main().gfCaption2.copyWith(
                        color: Theme.of(context).appColors.gfWarningColor,
                      ),
                    ),
                    onPressed: () {
                      _showIOSDialog(
                        context: context,
                        title: '이 댓글을 신고하시겠어요?',
                        body: '신고 사유를 정확히 선택해주세요. 잘못된 신고는 처리가 어려울 수 있어요.',
                        onConfirm: () async {
                          _showReportPicker(context, (String selectedReason) async {
                            final result = await ref
                                .read(postDetailViewModelProvider.notifier)
                                .reportComment(widget.post.id, widget.commentCreatId, userState.value?.id ?? '', selectedReason);

                            switch (result) {
                              case Success(value: final v):
                                postNotifier.showToast('신고가 정상적으로 접수되었습니다.\n운영팀이 확인 후 조치할 예정입니다.', ToastGravity.TOP, Theme.of(context).appColors.gfMainColor, Theme.of(context).appColors.gfWhiteColor);
                              case Failure(exception: final e):
                                postNotifier.showToast('에러가 발생했어요!', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                            }
                          });
                        },
                      );
                    },
                  )
                ],
              ),
              SizedBox(height: 5),
              Text(
                widget.commentText.length > 300
                    ? '${widget.commentText.substring(0, 300)}...'
                    : widget.commentText,
                style: AppTextsTheme.main().gfBody5.copyWith(
                  color: Theme.of(context).appColors.gfBlackColor,
                ),
              ),
            ],
          ),
        ),
      ],
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