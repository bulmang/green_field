import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/cores/router/router.dart';
import 'package:green_field/src/viewmodels/notice/notice_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/home/home_view_model.dart';
import 'package:green_field/src/views/home/sections/expiring_soon_recruit_section.dart';
import 'package:green_field/src/views/home/sections/notice_carousel_section.dart';
import '../../utilities/components/greefield_login_alert_dialog.dart';
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
    final userState = ref.watch(onboardingViewModelProvider);
    final noticeState = ref.watch(noticeViewModelProvider);

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
                    enabled: userState.isLoading,
                    effect: ShimmerEffect(
                      baseColor: Theme.of(context).appColors.gfMainBackGroundColor,
                      highlightColor: Theme.of(context).appColors.gfWhiteColor,
                      duration: const Duration(seconds: 2),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.go('/home/setting');
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Image.asset(
                          AppIcons.profile,
                          width: 40,
                          height: 40,
                        ),
                        title: Text(
                          userState.value?.name != null &&
                              userState.value!.name.isNotEmpty
                              ? userState.value!.name
                              : '(익명)',
                          style: AppTextsTheme.main().gfTitle1.copyWith(
                            color: Theme.of(context).appColors.gfBlackColor,
                          ),
                        ),
                        subtitle: Text(
                          userState.value != null
                              ? '${userState.value!.campus} 캠퍼스 ${userState.value!.course}'
                              : '서비스를 이용하려면 로그인해주세요.', // 실패 시 기본 메시지
                          style: AppTextsTheme.main().gfBody5.copyWith(
                            color: Theme.of(context).appColors.gfGray400Color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '공지사항',
                              style: AppTextsTheme.main().gfTitle2.copyWith(
                                    color: Theme.of(context)
                                        .appColors
                                        .gfBlackColor,
                                  ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (userState.value == null && !userState.isLoading) {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return GreenFieldLoginAlertDialog(ref: ref);
                                    },
                                  );
                                } else {
                                  context.go('/home/notice');
                                }
                              },
                              child: Text(
                                "더보기 >",
                                style: AppTextsTheme.main().gfCaption1.copyWith(
                                      color: Theme.of(context)
                                          .appColors
                                          .gfGray800Color,
                                    ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        noticeState.isLoading || userState.isLoading
                            ? Skeletonizer.zone(
                                effect: ShimmerEffect(
                                  baseColor: Theme.of(context).appColors.gfMainBackGroundColor,
                                  highlightColor:
                                      Theme.of(context).appColors.gfWhiteColor,
                                  duration: const Duration(seconds: 2),
                                ),
                                child: Card(
                                  shadowColor: Colors.transparent,
                                  color: Theme.of(context).appColors.gfWhiteColor,
                                  child: ListTile(
                                    trailing: Bone.square(size: 50),
                                    title: Bone.text(words: 2),
                                    subtitle: Bone.text(),
                                  ),
                                ),
                              )
                            : NoticeCarouselSection(),
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
