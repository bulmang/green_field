import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/datas/repositories/onboarding_repository.dart';
import 'package:green_field/src/viewmodels/login_view_model.dart';
import 'package:green_field/src/viewmodels/onboarding_view_model.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../datas/services/firebase_auth_service.dart';
import '../../utilities/components/greenfield_campus_picker.dart';
import '../../utilities/components/greenfield_confirm_button.dart';
import '../../utilities/components/greenfield_loading_widget.dart';
import '../../utilities/design_system/app_texts.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

import 'onboarding_text_field.dart';

class OnboardingView extends ConsumerStatefulWidget {
  OnboardingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingViewModelProvider);
    final course = ref.watch(courseTextFieldProvider); // course 상태 구독
    final campusState = ref.watch(campusProvider); // campus 상태 구독
    final tokenState = ref.watch(loginViewModelProvider);

    bool _isActive() {
      return course.isNotEmpty && campusState != '---';
    }

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Text(
                          '안녕하세요\n캠퍼스와 강의를 알려주세요.',
                          style: AppTextsTheme.main().gfHeading1.copyWith(
                                color: Theme.of(context).appColors.gfMainColor,
                              ),
                        ),
                        SizedBox(height: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "캠퍼스위치",
                              style: AppTextsTheme.main().gfTitle3.copyWith(
                                    color:
                                        Theme.of(context).appColors.gfGray800Color,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            GreenFieldCampusPicker(
                              onCampusSelected: (selectedCampus) {
                                ref
                                    .read(campusProvider.notifier)
                                    .updateSelectedCampus(selectedCampus);
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "학습 및 학습 완료 강좌",
                              style: AppTextsTheme.main().gfTitle3.copyWith(
                                    color:
                                        Theme.of(context).appColors.gfGray800Color,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            OnboardingTextField(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GreenFieldConfirmButton(
                    text: "시작하기",
                    isAble: _isActive(),
                    textColor: Theme.of(context).appColors.gfWhiteColor,
                    backGroundColor: _isActive()
                        ? Theme.of(context).appColors.gfMainColor
                        : Theme.of(context).appColors.gfGray300Color,
                    onPressed: () async {
                      final result = await ref
                          .read(onboardingViewModelProvider.notifier)
                          .createAuthUser(
                            tokenState.value?.provider ?? '',
                            tokenState.value?.idToken ?? '',
                            tokenState.value?.accessToken ?? '',
                          );

                      switch (result) {
                        case Success():
                          context.go('/home');

                        case Failure(exception: final e):
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('로그인 실패'),
                              content: Text('에러 발생: $e'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('확인'),
                                ),
                              ],
                            ),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          onboardingState.isLoading
              ? GreenFieldLoadingWidget()
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
