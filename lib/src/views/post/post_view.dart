import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/utilities/design_system/app_colors.dart';
import 'package:green_field/src/utilities/design_system/app_icons.dart';
import 'package:green_field/src/utilities/enums/feature_type.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../utilities/components/greefield_login_alert_dialog.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_list.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/user_type.dart';
import '../../viewmodels/post/post_detail_view_model.dart';
import '../../viewmodels/post/post_view_model.dart'; // Update to PostViewModel
import '../../viewmodels/onboarding/onboarding_view_model.dart';

class PostView extends ConsumerStatefulWidget {
  const PostView({super.key});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  final controller = ScrollController();

  bool hasMore = true;
  bool loading = false;

  Future refresh() async {
    final postNotifier = ref.watch(postViewModelProvider.notifier);
    final result = await postNotifier.getPostList();

    switch (result) {
      case Success():
        hasMore = true;

      case Failure(exception: final e):
        postNotifier.showToast(
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
    final postNotifier = ref.watch(postViewModelProvider.notifier);
    final result = await postNotifier.getNextPostList();
    setState(() {
      switch (result) {
        case Success(value: final value):
          if (value.isEmpty) {
            hasMore = false;
          }
          loading = false;

        case Failure(exception: final e):
          loading = false;
          postNotifier.showToast(
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
    final postState = ref.watch(postViewModelProvider);
    final postNotifier = ref.watch(postViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfBackGroundColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfBackGroundColor,
        leadingIcon: SizedBox(),
        title: "게시판",
        actions: [
            CupertinoButton(
              child: Icon(
                CupertinoIcons.square_pencil,
                size: 24,
                color: Theme.of(context).appColors.gfGray400Color,
              ),
              onPressed: () {
                if (userState.value == null && !userState.isLoading) {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return GreenFieldLoginAlertDialog(ref: ref);
                    },
                  );
                } else {
                  context.go('/post/edit');
                }
              },
            )
        ],
      ),
      body: (postState.value != null && postState.value!.isNotEmpty)
          ? RefreshIndicator(
              onRefresh: refresh,
              color: Theme.of(context).appColors.gfGray400Color,
              backgroundColor: Colors.white,
              strokeWidth: 2.0,
              child: Stack(
                children: [
                  ListView.builder(
                    controller: controller,
                    itemCount: postState.value!.length + 1,
                    itemBuilder: (context, index) {
                      if (index < postState.value!.length) {
                        final post = postState.value![index];
                        return postState.isLoading
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
                                  color: Theme.of(context).appColors.gfBackGroundColor,
                                  child: ListTile(
                                    trailing: Bone.square(size: 40),
                                    title: Bone.text(words: 2),
                                    subtitle: Bone.text(),
                                  ),
                                ),
                              )
                            : GreenFieldList(
                                featureType: FeatureType.post,
                                title: post.title,
                                content: post.body,
                                date: '${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day}',
                                campus: post.creatorCampus,
                                imageUrl:
                                    post.images != null && post.images!.isNotEmpty
                                        ? post.images![0]
                                        : "",
                                likes: post.like.length,
                                commentCount: post.commentCount,
                                onTap: () async {
                                  if (userState.value == null && !userState.isLoading) {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return GreenFieldLoginAlertDialog(ref: ref);
                                      },
                                    );
                                  } else {
                                    final postNotifier = ref.watch(postViewModelProvider.notifier);
                                    final result = await ref
                                        .read(postDetailViewModelProvider.notifier)
                                        .getCommentList(post.id);

                                    switch (result) {
                                      case Success(value: final v):
                                        print('성공 v: $v');
                                      case Failure(exception: final e):
                                        print('실패 v: $e');
                                        postNotifier.showToast(
                                          '에러가 발생했어요!',
                                          ToastGravity.TOP,
                                          Theme.of(context).appColors.gfWarningColor,
                                          Theme.of(context).appColors.gfWhiteColor,
                                        );
                                    }
                                    context.go('/post/detail/${post.id}');
                                  }
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
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
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
                                      color: Theme.of(context).appColors.gfBackGroundColor,
                                      height: 60,
                                    )
                              : GreenFieldList(
                                  title: '게시물이 없습니다.',
                                  content: '모든 게시물을 보셨어요!',
                                  date: '9999-01-17',
                                  campus: '개발자 생일',
                                  imageUrl:
                                      'https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/sesacGif.gif?alt=media',
                                  likes: 999,
                                  commentCount: 0,
                                  last: true,
                                  onTap: () {
                                    postNotifier.showToast(
                                        '더 이상 게시물이 없어요!',
                                        ToastGravity.BOTTOM,
                                        AppColorsTheme.main().gfWarningColor,
                                        AppColorsTheme.main().gfWhiteColor);
                                  },
                                ),
                        );
                      }
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: MediaQuery.of(context).size.width / 2 - 60,
                    child: CupertinoButton(
                      onPressed: () {
                        if (userState.value == null && !userState.isLoading) {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GreenFieldLoginAlertDialog(ref: ref);
                            },
                          );
                        } else {
                          context.go('/post/edit');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF308F5B), Color(0xFF666666)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.pencil,
                              color: Colors.white,
                            ),
                            SizedBox(width: 3), // Space between icon and text
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3.0, right: 5),
                              child: Text(
                                '글 쓰기',
                                style: AppTextsTheme.main().gfCaption2.copyWith(
                                  color: Theme.of(context).appColors.gfWhiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
