import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/model/recruit.dart';
import 'package:lottie/lottie.dart';
import '../design_system/app_icons.dart';
import '../design_system/app_texts.dart';
import '../enums/feature_type.dart';
import '../extensions/image_dimension_parser.dart';
import 'greenfield_cached_network_image.dart';
import 'greenfield_images_detail.dart';

class GreenFieldContentWidget extends StatelessWidget {
  final FeatureType? featureType;
  final String title;
  final String bodyText;
  final List<String?> imageAssets;
  final int? likes;
  final int? commentCount;
  final Recruit? recruit;

  GreenFieldContentWidget({
    super.key,
    this.featureType,
    required this.title,
    required this.bodyText,
    required this.imageAssets,
    this.likes,
    this.commentCount,
    this.recruit
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
                color: Theme.of(context).appColors.gfBlackColor,
              ),
            ),
            SizedBox(height: 17),
            Text(
              bodyText,
              style: AppTextsTheme.main().gfCaption2Light.copyWith(
                color: Theme.of(context).appColors.gfBlackColor,
              ),
            ),
            SizedBox(height: 17),
            // 이미지 표시 부분 수정
            if (imageAssets.length == 1 && imageAssets[0] != null)
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GreenFieldImagesDetail(
                          tags: imageAssets,
                          initialIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: imageAssets.first!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GreenFieldCachedNetworkImage(imageUrl: imageAssets.first!, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.width, scaleEffect: ImageDimensionParser().parseDimensions(imageAssets.first)),
                    ),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imageAssets.asMap().entries.map((entry) {
                    int index = entry.key;
                    String? imageUrl = entry.value;
                    if (imageUrl != null) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GreenFieldImagesDetail(
                                  tags: imageAssets,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: imageUrl,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: GreenFieldCachedNetworkImage(imageUrl: imageUrl, width: 120, height: 120, scaleEffect: ImageDimensionParser().parseDimensions(imageUrl)),
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
            featureType != FeatureType.recruit
                ? Row(
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
                      commentCount.toString(),
                      style: AppTextsTheme.main().gfCaption5.copyWith(
                        color: Theme.of(context).appColors.gfMainColor,
                      ),
                    ),
                  ],
                ),
              ],
            )
                : Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).appColors.gfGray800Color, // 테두리 색상
                      width: 1, // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: [
                        Image.asset(
                          AppIcons.tagIcon,
                          width: 9,
                          height: 9,
                        ),
                        SizedBox(width: 3),
                        Text(
                          recruit!.creatorCampus,
                          style: AppTextsTheme.main()
                              .gfCaption5
                              .copyWith(
                            color: Theme.of(context).appColors.gfGray800Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                if (recruit!.remainTime <= 30)
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).appColors
                          .gfWarningYellowBackGroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            AppIcons.alertCircle,
                            width: 9,
                            height: 9,
                          ),
                          SizedBox(width: 3),
                          Text(
                            "곧 사라져요!",
                            style: AppTextsTheme.main()
                                .gfCaption5
                                .copyWith(
                              color: Theme.of(context).appColors
                                  .gfWarningYellowColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      AppIcons.clockGreen,
                      width: 12,
                      height: 12,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '${recruit!.remainTime.toString()} min',
                      style: AppTextsTheme.main().gfCaption2Light.copyWith(
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
                      AppIcons.userGreen,
                      width: 12,
                      height: 12,
                    ),
                    SizedBox(width: 1),
                    Text(
                      '${recruit!.currentParticipants.length.toString()} / ${recruit!.maxParticipants.toString()}',
                      style: AppTextsTheme.main().gfCaption2Light.copyWith(
                        color: Theme.of(context).appColors.gfMainColor,
                      ),
                    ),
                  ],
                ),
              ],
            ) ,
          ],
        ),
      ),
    );
  }
}
