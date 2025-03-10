import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../cores/error_handler/result.dart';
import '../../../utilities/components/greefield_login_alert_dialog.dart';
import '../../../utilities/components/greenfield_cached_network_image.dart';
import '../../../utilities/design_system/app_icons.dart';
import '../../../utilities/design_system/app_texts.dart';
import '../../../utilities/extensions/image_dimension_parser.dart';
import '../../../viewmodels/notice/notice_view_model.dart';
import '../../../viewmodels/setting/setting_view_model.dart';

class NoticeCarouselSection extends ConsumerStatefulWidget {
  NoticeCarouselSection({super.key});

  @override
  NoticeCarouselSectionState createState() => NoticeCarouselSectionState();
}

class NoticeCarouselSectionState extends ConsumerState<NoticeCarouselSection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final noticeState = ref.watch(noticeViewModelProvider);

    if (noticeState.value!.isNotEmpty) {
      return Column(
        children: [
          CarouselSlider(
            items: noticeState.value?.take(3).toList().map((notice) {
              return Builder(
                builder: (context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Theme.of(context).appColors.gfWhiteColor,
                    
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (userState.value == null && !userState.isLoading) {
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return GreenFieldLoginAlertDialog(ref: ref);
                              },
                            );
                          } else {
                            context.go('/home/notice/detail/${notice.id}');
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notice.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextsTheme.main().gfTitle1.copyWith(
                                            color: Theme.of(context).appColors.gfBlackColor,
                                      ),
                                    ),
                                    Text(
                                      notice.body,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          AppTextsTheme.main().gfBody4.copyWith(
                                            color: Theme.of(context).appColors.gfBlackColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (notice.images != null &&
                                notice.images!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 7, bottom: 7, right: 12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                  GreenFieldCachedNetworkImage(imageUrl: notice.images!.first, width: 60, height: 60, scaleEffect: ImageDimensionParser().parseDimensions(notice.images!.first))
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 70,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 6),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index; // Update the current index
                });
              },
            ),
          ),
          SizedBox(height: 8), // Space between carousel and indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: noticeState.value!.take(3).toList().asMap().entries.map((entry) {
              int index = entry.key;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Theme.of(context).appColors.gfMainColor // Active color
                      : Theme.of(context)
                          .appColors
                          .gfGray300Color, // Inactive color
                ),
              );
            }).toList(),
          ),
        ],
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 86,
          color: Theme.of(context).appColors.gfWhiteColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '공지사항이 없습니다.',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextsTheme.main().gfTitle1.copyWith(
                              color: Theme.of(context).appColors.gfBlackColor,
                            ),
                      ),
                      Text(
                        '해당 캠퍼스 공지사항이 없습니다. 캠퍼스 관리자님께 문의부탁드립니다.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextsTheme.main().gfBody4.copyWith(
                              color: Theme.of(context).appColors.gfBlackColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 14, bottom: 7, right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    AppIcons.seatingSesac,
                    width: 60,
                    height: 60,
                  ),
                ),
              )
            ],
          ),
        ),
      );
      ;
    }
  }
}
