import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import '../../../design_system/app_colors.dart';
import '../../../design_system/app_texts.dart';
import '../../../model/notice.dart';

class NoticeCarousel extends StatefulWidget {
  final List<Notice> notices;

  NoticeCarousel({super.key, required this.notices});

  @override
  NoticeCarouselState createState() => NoticeCarouselState();
}

class NoticeCarouselState extends State<NoticeCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.notices.map((notice) {
            return Builder(
              builder: (context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: AppColorsTheme().gfWhiteColor,
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
                                    color: AppColorsTheme().gfBlackColor,
                                  ),
                                ),
                                Text(
                                  notice.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextsTheme.main().gfBody4.copyWith(
                                    color: AppColorsTheme().gfBlackColor,
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
          children: widget.notices.asMap().entries.map((entry) {
            int index = entry.key;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? AppColorsTheme().gfMainColor // Active color
                    : AppColorsTheme().gfGray300Color, // Inactive color
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}