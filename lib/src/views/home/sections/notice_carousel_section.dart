import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

import '../../../design_system/app_texts.dart';
import '../../../viewmodels/notice_view_model.dart';

class NoticeCarouselSection extends StatefulWidget {
  NoticeCarouselSection({super.key});

  @override
  NoticeCarouselSectionState createState() => NoticeCarouselSectionState();
}

class NoticeCarouselSectionState extends State<NoticeCarouselSection> {
  int _currentIndex = 0;
  final noticeVM = NoticeViewModel();

  @override
  Widget build(BuildContext context) {
    final notices = noticeVM.notices.take(3).toList();

    return Column(
      children: [
        CarouselSlider(
          items: notices.map((notice) {
            return Builder(
              builder: (context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Theme.of(context).appColors.gfWhiteColor,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.go('/home/notice/detail/${notice.id}');
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
                                    style: AppTextsTheme.main().gfBody4.copyWith(
                                      color: Theme.of(context).appColors.gfBlackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (notice.images != null && notice.images!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 7, bottom: 7, right: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  notice.images!.first,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
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
          children: notices.asMap().entries.map((entry) {
            int index = entry.key;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Theme.of(context).appColors.gfMainColor // Active color
                    : Theme.of(context).appColors.gfGray300Color, // Inactive color
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}