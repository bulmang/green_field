import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/home/home_view_model.dart';
import 'package:green_field/src/views/home/sections/expiring_soon_recruit_section.dart';
import 'package:green_field/src/views/home/sections/notice_carousel_section.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../viewmodels/onboarding/onboarding_view_model.dart';
import 'sections/external_link_section.dart';
import 'sections/top_liked_posts_section.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfBackGroundColor,
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
                  Skeletonizer(
                    enabled: onboardingState.isLoading,
                    effect: ShimmerEffect(
                      baseColor: Theme.of(context).appColors.gfMainBackGroundColor,
                      highlightColor: Theme.of(context).appColors.gfWhiteColor,
                      duration: const Duration(seconds: 2),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(
                        AppIcons.profile,
                        width: 40,
                        height: 40,
                      ),
                      title: Text(
                        onboardingState.value?.name != null && onboardingState.value!.name.isNotEmpty
                            ? onboardingState.value!.name
                            : '(익명)',
                        style: AppTextsTheme.main().gfTitle1.copyWith(
                          color: Theme.of(context).appColors.gfBlackColor,
                        ),
                      ),
                      subtitle: Text(
                        onboardingState.value != null
                            ? '${onboardingState.value!.campus} 캠퍼스 ${onboardingState.value!.course}'
                            : '서비스를 이용하려면 로그인해주세요.', // 실패 시 기본 메시지
                        style: AppTextsTheme.main().gfBody5.copyWith(
                          color: Theme.of(context).appColors.gfGray400Color,
                        ),
                      ), // 서브타이틀 텍스트
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
