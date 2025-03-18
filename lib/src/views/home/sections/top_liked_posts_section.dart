import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:intl/intl.dart';

import '../../../cores/error_handler/result.dart';
import '../../../utilities/components/greefield_login_alert_dialog.dart';
import '../../../utilities/design_system/app_texts.dart';
import '../../../utilities/design_system/app_icons.dart';
import '../../../model/post.dart';
import '../../../viewmodels/post/post_detail_view_model.dart';
import '../../../viewmodels/post/post_view_model.dart';

class TopLikedPostsSection extends ConsumerStatefulWidget {

  const TopLikedPostsSection({super.key});

  @override
  _TopLikedPostsSection createState() => _TopLikedPostsSection();
}
class _TopLikedPostsSection extends ConsumerState<TopLikedPostsSection> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.read(onboardingViewModelProvider);
    final postState = ref.watch(postViewModelProvider);
    final postNotifier = ref.watch(postViewModelProvider.notifier);

    bool isIPhoneSE = MediaQuery.of(context).size.width <= 375;
    final topList = (postState.value ?? [])
        .toList() // 리스트 복사 (원본 유지)
      ..sort((a, b) => b.like.length.compareTo(a.like.length)); // 내림차순 정렬

    final top3List = topList.take(3).toList(); // 상위 3개 가져오기

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...top3List.take(isIPhoneSE ? 2 : 3).toList().asMap().entries.map((entry) {
          int index = entry.key;
          Post post = entry.value;
          String formattedDate = DateFormat('MM/dd').format(post.createdAt);

          return Column(
            children: [
              if (index == 1) Container(height: 1, color: Theme.of(context).appColors.gfGray300Color),
              Container(
                color: Theme.of(context).appColors.gfWhiteColor,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    if (userState.value == null && !userState.isLoading) {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return GreenFieldLoginAlertDialog(ref: ref);
                        },
                      );
                    } else {
                      final result = await ref
                          .read(postDetailViewModelProvider.notifier)
                          .getCommentList(post.id);

                      switch (result) {
                        case Success(value: final v):
                          context.go('/post/detail/${post.id}');
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
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                maxLines: 1,
                                style: AppTextsTheme.main().gfHeading3.copyWith(
                                  color: Theme.of(context).appColors.gfBlackColor,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: AppTextsTheme.main().gfCaption5.copyWith(
                                      color: Theme.of(context).appColors.gfGray800Color,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    post.creatorCampus,
                                    style: AppTextsTheme.main().gfCaption5.copyWith(
                                      color: Theme.of(context).appColors.gfMainColor,
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(width: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(
                                        AppIcons.thumbnailUp,
                                        width: 14,
                                        height: 12,
                                      ),
                                      SizedBox(width: 1),
                                      Text(
                                        post.like.length.toString(),
                                        style: AppTextsTheme.main().gfCaption5.copyWith(
                                          color: Theme.of(context).appColors.gfMainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(
                                        AppIcons.messageCircle,
                                        width: 14,
                                        height: 12,
                                      ),
                                      SizedBox(width: 1),
                                      Text(
                                        '${post.commentCount}',
                                        style: AppTextsTheme.main().gfCaption5.copyWith(
                                          color: Theme.of(context).appColors.gfMainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (index == 1) Container(height: 1, color: Theme.of(context).appColors.gfGray300Color),
            ],
          );
        }),
      ],
    );
  }
}
