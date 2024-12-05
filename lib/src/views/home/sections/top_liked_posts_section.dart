import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:green_field/src/design_system/app_icons.dart';
import '../../../design_system/app_colors.dart';
import '../../../design_system/app_texts.dart';
import '../../../model/post.dart';
import '../../../viewmodels/post_view_model.dart';

class TopLikedPostsSection extends StatelessWidget {

  const TopLikedPostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final postVM = PostViewModel();
    bool isIPhoneSE = MediaQuery.of(context).size.width <= 375;
    List<Post> topPosts = postVM.getTopLikedPosts(3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...topPosts.take(isIPhoneSE ? 2 : 3).toList().asMap().entries.map((entry) {
          int index = entry.key;
          Post post = entry.value;
          String formattedDate = DateFormat('MM/dd').format(post.createdAt);

          return Column(
            children: [
              if (index == 1) Container(height: 1, color: AppColorsTheme().gfGray300Color),
              Container(
                color: AppColorsTheme().gfWhiteColor,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.go('/post/detail/${post.id}');
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
                                  color: AppColorsTheme().gfBlackColor,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: AppTextsTheme.main().gfCaption5.copyWith(
                                      color: AppColorsTheme().gfGray800Color,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    post.creatorCampus,
                                    style: AppTextsTheme.main().gfCaption5.copyWith(
                                      color: AppColorsTheme().gfMainColor,
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
                                          color: AppColorsTheme().gfMainColor,
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
                                        '0',
                                        style: AppTextsTheme.main().gfCaption5.copyWith(
                                          color: AppColorsTheme().gfMainColor,
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
              if (index == 1) Container(height: 1, color: AppColorsTheme().gfGray300Color),
            ],
          );
        }),
      ],
    );
  }
}
