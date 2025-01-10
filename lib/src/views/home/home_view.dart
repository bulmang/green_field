import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/home_view_model.dart';
import 'package:green_field/src/views/home/sections/expiring_soon_recruit_section.dart';
import 'package:green_field/src/views/home/sections/notice_carousel_section.dart';
import '../../cores/error_handler/result.dart';
import '../../model/user.dart' as myUser;
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../viewmodels/onboarding_view_model.dart';
import 'sections/external_link_section.dart';
import 'sections/top_liked_posts_section.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>{
  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingViewModelProvider);
    final homeState = ref.watch(homeViewModelProvider);
    print('homeState: ${homeState.value}');
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
                  onboardingState.isLoading ? const CircularProgressIndicator() : const SizedBox.shrink(),
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
                            onboardingState.isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                              onboardingState.value != null
                                  ? onboardingState.value!.name
                                  : 'null',
                              style: AppTextsTheme.main().gfTitle1.copyWith(
                                color: Theme.of(context).appColors.gfBlackColor,
                              ),
                            ),
                            SizedBox(height: 3),
                            onboardingState.isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                              onboardingState.value != null
                                  ? onboardingState.value!.campus + '캠퍼스' + ' ' + onboardingState.value!.course // 성공 시 course 프로퍼티
                                  : 'null', // 실패 시 기본 메시지
                              style: AppTextsTheme.main().gfBody5.copyWith(
                                color: Theme.of(context).appColors.gfGray400Color,
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
                          '공지사항',
                          style: AppTextsTheme.main().gfTitle2.copyWith(
                                color: Theme.of(context).appColors.gfBlackColor,
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
                            color: Theme.of(context).appColors.gfBlackColor,
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
                    color: Theme.of(context).appColors.gfBlackColor,
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
