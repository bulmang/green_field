import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_icons.dart';
import '../design_system/app_texts.dart';

class GreenFieldContentWidget extends StatelessWidget {
  final String title;
  final String bodyText;
  final List<String?> imageAssets;
  final int likes;
  final int commentCount;

  GreenFieldContentWidget({
    super.key,
    required this.title,
    required this.bodyText,
    required this.imageAssets,
    required this.likes,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextsTheme.main().gfHeading1.copyWith(
                color: AppColorsTheme().gfBlackColor,
              ),
            ),
            SizedBox(height: 17),
            Text(
              bodyText,
              style: AppTextsTheme.main().gfCaption2Light.copyWith(
                color: AppColorsTheme().gfBlackColor,
              ),
            ),
            SizedBox(height: 17),
            // 이미지 표시 부분 수정
            if (imageAssets.length == 1 && imageAssets[0] != null)
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageAssets[0]!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imageAssets.map((imageUrl) {
                    if (imageUrl != null) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 120, // 정사각형 너비
                            height: 120, // 정사각형 높이
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ),
              ),
            if (imageAssets.isNotEmpty) SizedBox(height: 17),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                      likes.toString(),
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
                      commentCount.toString(),
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
    );
  }
}
