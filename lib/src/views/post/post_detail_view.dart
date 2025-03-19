import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/model/comment.dart';
import 'package:green_field/src/viewmodels/post/post_detail_view_model.dart';
import 'package:green_field/src/viewmodels/post/post_edit_view_model.dart';
import 'package:green_field/src/viewmodels/post/post_view_model.dart';
import '../../cores/error_handler/result.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_comment_widget.dart';
import '../../utilities/components/greenfield_content_widget.dart';
import '../../utilities/components/greenfield_loading_widget.dart';
import '../../utilities/components/greenfield_text_field.dart';
import '../../utilities/components/greenfield_user_info_widget.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/feature_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/model/post.dart';

import '../../viewmodels/onboarding/onboarding_view_model.dart';

  class PostDetailView extends ConsumerStatefulWidget {
    final String postId; // Assuming BoardPost is your model

    const PostDetailView({super.key, required this.postId});

    @override
    _PostDetailViewState createState() => _PostDetailViewState();
  }

class _PostDetailViewState extends ConsumerState<PostDetailView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
      final userState = ref.watch(onboardingViewModelProvider);
      final postNotifier = ref.watch(postViewModelProvider.notifier);
      final postEditState = ref.watch(postEditViewModelProvider);
      final postState = ref.watch(postViewModelProvider);
      final postDetailState = ref.watch(postDetailViewModelProvider);
      final currentPost = postState.value?.firstWhere((post) => post.id == widget.postId, orElse: () => Post(id: 'id', creatorId: 'creatorId', creatorCampus: 'creatorCampus', createdAt: DateTime.now(), title: 'title', body: 'body', like: [],commentCount: 0));

      return Stack(
      children: [
        currentPost != null
         ? Scaffold(
          backgroundColor: Theme.of(context).appColors.gfWhiteColor,
          appBar: GreenFieldAppBar(
            backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
            title: _getLimitedTitle(currentPost.title, 20),
            actions: [
              CupertinoButton(
                      child: Icon(CupertinoIcons.ellipsis,color: Theme.of(context).appColors.gfGray400Color),
                      onPressed: () {
                        if (postNotifier.checkAuth(userState.value?.userType, userState.value?.id ?? '', currentPost.creatorId)) {
                          _showCupertinoActionSheet(
                            context,
                            currentPost, // 현재 공지사항 객체
                            ref.read(postEditViewModelProvider.notifier),
                            ref.read(postViewModelProvider.notifier),
                          );
                        } else {
                          _showOtherUserCupertinoActionSheet(
                            context, () {
                              _showIOSDialog(
                                context: context,
                                title: '이 게시글을 신고하시겠어요?',
                                body: '신고 사유를 정확히 선택해주세요.\n잘못된 신고는 처리가 어려울 수 있어요.\n신고하면 글이 보이지 않아요.',
                                onConfirm: () async {
                                  _showReportPicker(context, (String selectedReason) async {
                                    final result = await ref
                                        .read(postViewModelProvider.notifier)
                                        .reportPost(currentPost.id, userState.value?.id ?? '', selectedReason);

                                    switch (result) {
                                      case Success(value: final v):
                                        final refreshPostList = await ref.read(postViewModelProvider.notifier).getPostList();

                                        switch(refreshPostList) {
                                          case Success():
                                            context.pop();
                                            postNotifier.showToast('신고가 정상적으로 접수되었습니다.\n운영팀이 확인 후 조치할 예정입니다.', ToastGravity.TOP, Theme.of(context).appColors.gfMainColor, Theme.of(context).appColors.gfWhiteColor);
                                          case Failure(exception: final e):
                                            postNotifier.showToast('에러가 발생했어요!', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                                        }

                                      case Failure(exception: final e):
                                        postNotifier.showToast('에러가 발생했어요!', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                                    }
                                  });
                                },
                              );
                            },
                                () {
                                  _showIOSDialog(
                                    context: context,
                                    title: '글 작성자를 차단하시겠습니까?',
                                    body: '이 작성자의 게시물이 목록에 노출되지 않으며, 다시 해제하실 수 없습니다.',
                                    onConfirm: () async {
                                      final result = await ref
                                          .read(postViewModelProvider.notifier)
                                          .blockUser(currentPost, userState.value?.id ?? '');

                                      switch (result) {
                                        case Success(value: final v):
                                          final refreshPostList = await ref.read(postViewModelProvider.notifier).getPostList();

                                          switch(refreshPostList) {
                                            case Success():
                                              context.pop();
                                              postNotifier.showToast('글 작성자를 차단하였습니다.', ToastGravity.TOP, Theme.of(context).appColors.gfMainColor, Theme.of(context).appColors.gfWhiteColor);
                                            case Failure(exception: final e):
                                              postNotifier.showToast('에러가 발생했어요!', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                                          }

                                        case Failure(exception: final e):
                                          postNotifier.showToast('에러가 발생했어요!', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                                      }
                                    },
                                  );
                            },
                          );
                        }
                      },
                  )

            ],
          ),
          body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GreenfieldUserInfoWidget(
                            featureType: FeatureType.post,
                            campus: currentPost.creatorCampus,
                            createTimeText:
                                '${currentPost.createdAt.year}-${currentPost.createdAt.month}-${currentPost.createdAt.day}',
                          ),
                        ),
                        GreenFieldContentWidget(
                          featureType: FeatureType.post,
                          title: currentPost.title,
                          bodyText: currentPost.body,
                          imageAssets: currentPost.images != null && currentPost.images!.isNotEmpty
                              ? currentPost.images!
                              : [],
                          likes: currentPost.like.length,
                          likesExist: currentPost.like.contains(userState.value?.id),
                          commentCount: currentPost.commentCount,
                          onTap: () async {
                            if (currentPost.like.contains(userState.value?.id)) {
                              postNotifier.showToast('이 글에 이미 좋아요를 눌렀어요!', ToastGravity.TOP, Theme.of(context).appColors.gfMainColor, Theme.of(context).appColors.gfWhiteColor);
                            } else {
                              final result = await ref
                                  .read(postViewModelProvider.notifier)
                                  .addLikeToPost(currentPost.id, userState.value?.id ?? '');

                              switch (result) {
                                case Success(value: final v):
                                  print(v);
                                case Failure(exception: final e):
                                  print('e:$e');
                                  postNotifier.showToast('에러가 발생했어요! $e', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                              }
                            }
                          },
                        ),
                        ...postDetailState.value?.map((comment) {
                          return GreenFieldCommentWidget(
                            commetId: comment.id,
                            campus: comment.creatorCampus,
                            dateTime: comment.createdAt,
                            commentText: comment.body,
                            commentCreatId: comment.creatorId,
                            post: currentPost,
                          );
                        }) ?? []
                      ],
                    ),
                  ),
                ),
                GreenFieldTextField(
                  type: FeatureType.post,
                  onAction: (String text) async {

                    final result = await ref
                        .read(postDetailViewModelProvider.notifier)
                        .createComment(currentPost, userState.value!, text);

                    switch (result) {
                      case Success(value: final v):
                        final result = await ref
                            .read(postDetailViewModelProvider.notifier)
                            .getCommentList(currentPost.id);

                        switch (result) {
                          case Success(value: final v):
                            final result = await ref
                                .read(postViewModelProvider.notifier)
                                .updateCommentCount(currentPost.id);

                            switch (result) {
                              case Success(value: final v):
                                print(v);
                              case Failure(exception: final e):
                                postNotifier.showToast('에러가 발생했어요!', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                            }

                            FocusScope.of(context).unfocus();
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );

                          case Failure(exception: final e):
                            print('실패 v: $e');
                            FocusScope.of(context).unfocus();
                            postNotifier.showToast(
                              '에러가 발생했어요!',
                              ToastGravity.TOP,
                              Theme.of(context).appColors.gfWarningColor,
                              Theme.of(context).appColors.gfWhiteColor,
                            );
                        }
                      case Failure(exception: final e):
                        print('e:$e');
                        postNotifier.showToast('에러가 발생했어요! $e', ToastGravity.TOP, Theme.of(context).appColors.gfWarningColor, Theme.of(context).appColors.gfWhiteColor);
                    }
                  },
                ),
              ],
            ),
          ),
        )
          : SizedBox.shrink(),
        postEditState.isLoading || postState.isLoading || postDetailState.isLoading
            ? GreenFieldLoadingWidget()
            : SizedBox.shrink(),
      ],
    );
  }

  /// AppBar에 들어갈 제목의 글자 수를 제한하는 함수
  String _getLimitedTitle(String title, int maxLength) {
    if (title.length > maxLength) {
      return '${title.substring(0, maxLength)}...';
    }
    return title;
  }
}

void _showCupertinoActionSheet(
    BuildContext context,
    Post post,
    PostEditViewModel postEditState,
    PostViewModel postState,
    ) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              '수정하기',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                color: Theme.of(context).appColors.gfBlueColor,
              ),
            ),
            onPressed: () {
              context.go('/post/edit/modify/${post.id}');
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
              final result = await postEditState.deletePostModel(post.id);

              switch (result) {
                case Success():
                  context.go('/post');
                  final updateResult = await postState.deletePostInList(post.id);

                  switch (updateResult) {
                    case Success():

                      Navigator.pop(context);
                    case Failure(exception: final e):
                      postEditState.flutterToast('에러발생');
                  }
                case Failure(exception: final e):
                  postEditState.flutterToast(e.toString());
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

void _showOtherUserCupertinoActionSheet(
    BuildContext context,
    void Function() onReportPressed,
    void Function() onBlockPressed,
    ) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              '게시글 신고하기',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                color: Theme.of(context).appColors.gfWarningColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onReportPressed();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              '사용자 차단하기',
              style: AppTextsTheme.main().gfTitle2.copyWith(
                color: Theme.of(context).appColors.gfWarningColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onBlockPressed();
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
            Navigator.pop(context);
          },
        ),
      );
    },
  );
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
