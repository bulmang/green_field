import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../design_system/app_icons.dart';
import '../design_system/app_texts.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

import 'greenfield_cached_network_image.dart';

class GreenFieldList extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String campus;
  final String imageUrl;
  final int likes;
  final int commentCount;
  final VoidCallback onTap;
  final bool? last;

  const GreenFieldList(
      {super.key,
      required this.title,
      required this.content,
      required this.date,
      required this.campus,
      required this.imageUrl,
      required this.likes,
      required this.commentCount,
      required this.onTap,
      this.last});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Material(
        color: Colors.transparent, // 배경색 투명 설정
        child: Column(
          children: [
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: imageUrl.isNotEmpty ? 14.0 : 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            style: AppTextsTheme.main().gfHeading3.copyWith(
                                  color: Theme.of(context).appColors.gfBlackColor,
                                ),
                          ),
                          Text(
                            content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextsTheme.main().gfCaption2Light.copyWith(
                                  color: Theme.of(context).appColors.gfBlackColor,
                                ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: AppTextsTheme.main().gfCaption5.copyWith(
                                  color: Theme.of(context).appColors.gfGray800Color,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                campus,
                                style: AppTextsTheme.main().gfCaption5.copyWith(
                                      color: Theme.of(context).appColors.gfMainColor,
                                    ),
                              ),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (imageUrl.isNotEmpty)
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Transform.scale(
                          scale: 1.5,
                            child: GreenFieldCachedNetworkImage(imageUrl: imageUrl, width: 60, height: 60))
                    )
                ],
              ),
            ),
            SizedBox(height: 6),
            if (last == null || last == false)
              Divider(
                height: 2,
                color: Theme.of(context).appColors.gfGray300Color,
              )
            else
              SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
