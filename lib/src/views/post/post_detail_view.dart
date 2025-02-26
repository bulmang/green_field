import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/viewmodels/post/post_edit_view_model.dart';
import 'package:green_field/src/viewmodels/post/post_view_model.dart';
import '../../cores/error_handler/result.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_comment_widget.dart';
import '../../utilities/components/greenfield_content_widget.dart';
import '../../utilities/components/greenfield_text_field.dart';
import '../../utilities/components/greenfield_user_info_widget.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/feature_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/model/post.dart';

import '../../viewmodels/onboarding/onboarding_view_model.dart';

class PostDetailView extends ConsumerStatefulWidget {
  final Post post; // Assuming BoardPost is your model

  const PostDetailView({super.key, required this.post});

  @override
  _PostDetailViewState createState() => _PostDetailViewState();
}

class _PostDetailViewState extends ConsumerState<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final userState = ref.watch(onboardingViewModelProvider);
    final postNotifier = ref.watch(postViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: _getLimitedTitle(post.title, 20),
        actions: [
          if (postNotifier.checkAuth(userState.value?.userType, userState.value?.id ?? '', post.creatorId))
            CupertinoButton(
                child: ImageIcon(
                  AssetImage(AppIcons.menu),
                  size: 24,
                  color: Theme.of(context).appColors.gfGray400Color,
                ),
                onPressed: () {
                  _showCupertinoActionSheet(
                    context,
                    post, // 현재 공지사항 객체
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
                        campus: post.creatorCampus,
                        createTimeText:
                            '${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day}',
                      ),
                    ),
                    GreenFieldContentWidget(
                      title: post.title,
                      bodyText: post.body,
                      imageAssets: post.images != null && post.images!.isNotEmpty
                          ? post.images!
                          : [],
                      likes: post.like.length,
                      commentCount: post.comment?.length ??
                          0, // Assuming you have comments in your model
                    ),
                    ...post.comment!.map((comment) {
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
                  postState.deletePostInList(post.id);
                  Navigator.pop(context);
                  context.go('/post');
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