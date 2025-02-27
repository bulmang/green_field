import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
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

    @override
    Widget build(BuildContext context) {
      final userState = ref.watch(onboardingViewModelProvider);
      final postNotifier = ref.watch(postViewModelProvider.notifier);
      final postEditState = ref.watch(postEditViewModelProvider);
      final postState = ref.watch(postViewModelProvider);
      final currentPost = postState.value?.firstWhere((post) => post.id == widget.postId, orElse: () => Post(id: 'id', creatorId: 'creatorId', creatorCampus: 'creatorCampus', createdAt: DateTime.now(), title: 'title', body: 'body', like: []));

      return Stack(
      children: [
        currentPost != null
         ? Scaffold(
          backgroundColor: Theme.of(context).appColors.gfWhiteColor,
          appBar: GreenFieldAppBar(
            backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
            title: _getLimitedTitle(currentPost.title, 20),
            actions: [
              if (postNotifier.checkAuth(userState.value?.userType, userState.value?.id ?? '', currentPost.creatorId))
                CupertinoButton(
                    child: ImageIcon(
                      AssetImage(AppIcons.menu),
                      size: 24,
                      color: Theme.of(context).appColors.gfGray400Color,
                    ),
                    onPressed: () {
                      _showCupertinoActionSheet(
                        context,
                        currentPost, // 현재 공지사항 객체
                        ref.read(postEditViewModelProvider.notifier),
                        ref.read(postViewModelProvider.notifier),
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
                  child: SingleChildScrollView(
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
                          commentCount: currentPost.comment?.length ?? 0, // Assuming you have comments in your model
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
                        ...currentPost.comment!.map((comment) {
                          // Assuming each comment has properties like campus, dateTime, and content
                          return GreenFieldCommentWidget(
                            campus: comment
                                .creatorCampus, // Assuming comment has a campus property
                            dateTime: comment
                                .createdAt, // Assuming comment has a dateTime property
                            comment: comment
                                .body, // Assuming comment has a content property
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                GreenFieldTextField(
                  type: FeatureType.post,
                  onAction: (String text) {
                    // TODO: Implement onAction
                  },
                ),
              ],
            ),
          ),
        )
          : SizedBox.shrink(),
        postEditState.isLoading || postState.isLoading
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
              '글 수정',
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