import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:green_field/src/design_system/app_icons.dart';
import '../../../design_system/app_colors.dart';
import '../../../design_system/app_texts.dart';
import '../../../model/post.dart';

class TopLikedPostsSection extends StatelessWidget {
  final List<Post> posts;

  const TopLikedPostsSection({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    bool isIPhoneSE = MediaQuery.of(context).size.width <= 375;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...posts.take(isIPhoneSE ? 2 : 3).toList().asMap().entries.map((entry) {
          int index = entry.key;
          Post post = entry.value;
          String formattedDate = DateFormat('MM/dd').format(post.createdAt);

          return Column(
            children: [
              if (index == 1) Container(height: 1, color: AppColorsTheme().gfGray300Color),
              Container(
                color: AppColorsTheme().gfWhiteColor,
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
              if (index == 1) Container(height: 1, color: AppColorsTheme().gfGray300Color),
            ],
          );
        }),
      ],
    );
  }
}
