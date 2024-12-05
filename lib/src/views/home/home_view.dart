import 'package:flutter/material.dart';
import 'package:green_field/src/views/home/sections/expiring_soon_recruit_section.dart';
import 'package:green_field/src/design_system/app_icons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_texts.dart';
import '../../viewmodels/user_view_model.dart';
import 'sections/external_link_section.dart';
import 'sections/notice_carousel.dart';
import 'sections/top_liked_posts_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final userVM = UserViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppIcons.profile,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '익명(${userVM.user.campus})',
                              style: AppTextsTheme.main().gfTitle1.copyWith(
                                    color: AppColorsTheme().gfBlackColor,
                                  ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              userVM.user.course,
                              style: AppTextsTheme.main().gfBody5.copyWith(
                                    color: AppColorsTheme().gfGray400Color,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userVM.user.campus} 공지사항',
                          style: AppTextsTheme.main().gfTitle2.copyWith(
                                color: AppColorsTheme().gfBlackColor,
                              ),
                        ),
                        SizedBox(height: 5),
                        NoticeCarouselSection(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: ExternalLinkSection(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HOT 게시판',
                          style: AppTextsTheme.main().gfTitle2.copyWith(
                            color: AppColorsTheme().gfBlackColor,
                          ),
                        ),
                        SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TopLikedPostsSection(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  '곧 사라지는 실시간 모집글',
                  style: AppTextsTheme.main().gfTitle2.copyWith(
                    color: AppColorsTheme().gfBlackColor,
                  ),
                ),
              ),
              ExpiringSoonRecruitSection()
            ],
          ),
        ),
      ),
    );
  }
}
