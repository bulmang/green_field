import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/cores/image_type/image_type.dart';
import 'package:green_field/src/utilities/components/greenfield_loading_widget.dart';
import 'package:green_field/src/viewmodels/post/post_edit_view_model.dart';
import 'package:green_field/src/viewmodels/post/post_view_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../cores/error_handler/result.dart';
import '../../model/post.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_edit_section.dart';
import '../../utilities/enums/feature_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../viewmodels/onboarding/onboarding_view_model.dart';

class PostEditView extends ConsumerStatefulWidget {
  final Post? post;
  const PostEditView({super.key, this.post});

  @override
  _PostEditViewState createState() => _PostEditViewState();
}

class _PostEditViewState extends ConsumerState<PostEditView> {
  ValueNotifier<bool> isCompleteActive = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final postEditState = ref.watch(postEditViewModelProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).appColors.gfWhiteColor,
          appBar: GreenFieldAppBar(
            backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
            title: "게시글 쓰기",
            leadingIcon: Icon(
              CupertinoIcons.xmark,
              color: Theme.of(context).appColors.gfGray400Color,
            ),
            leadingAction: () {
              context.pop();
            },
            actions: [
              CupertinoButton(
                onPressed: () async {
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
            instanceModel: widget.post,
            type: FeatureType.post,
            onSubmit: (String title, String body, List<ImageType> images) async {
              print('출력');
              if (images.length > 8) {
                ref
                    .read(postEditViewModelProvider.notifier)
                    .flutterToast('사진은 최대 8장까지 업로드할 수 있어요.');
                return;
              }
              if (title != '' && body != '') {
                final result = await ref
                    .read(postEditViewModelProvider.notifier)
                    .createPostModel(userState.value, title, body, images, widget.post);

                switch (result) {
                  case Success(value: final value):
                    final getPost = await ref
                        .read(postViewModelProvider.notifier)
                        .getPost(widget.post?.id ?? value.id);

                    switch (getPost) {
                      case Success(value: final value):
                        if (widget.post == null) {
                          final getPostList = await ref
                              .read(postViewModelProvider.notifier)
                              .getPostList();

                          switch (getPostList) {
                            case Success():
                              context.go('/post/detail/${value.id}');
                            case Failure(exception: final e):
                              print('getPostList:$e');
                              ref
                                  .read(postEditViewModelProvider.notifier)
                                  .flutterToast('게시글을 가져오기 실패하였습니다.');
                          }
                        } else {
                          context.go('/post/detail/${value.id}');
                        }

                      case Failure(exception: final e):
                        print('getPost:$e');
                        ref
                            .read(postEditViewModelProvider.notifier)
                            .flutterToast('게시글을 가져오기 실패하였습니다.');
                    }

                  case Failure(exception: final e):
                    ref
                        .read(postEditViewModelProvider.notifier)
                        .flutterToast('공지사항 등록에 실패하였습니다.${e.toString()}');
                }
              } else {
                ref
                    .read(postEditViewModelProvider.notifier)
                    .flutterToast('제목과 내용을 입력해주세요.');
                isCompleteActive.value = !isCompleteActive.value;
              }
            },
            isCompleteActive: isCompleteActive,
          ),
        ),
        postEditState.isLoading
          ? GreenFieldLoadingWidget()
          : SizedBox.shrink(),
      ],
    );
  }
}
