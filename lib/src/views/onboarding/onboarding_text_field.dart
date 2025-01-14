import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/design_system/app_colors.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../viewmodels/onboarding_view_model.dart';

class OnboardingTextField extends ConsumerStatefulWidget {
  @override
  _OnboardingTextFieldState createState() => _OnboardingTextFieldState();
}

class _OnboardingTextFieldState extends ConsumerState<OnboardingTextField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(); // 컨트롤러 초기화
  }

  @override
  void dispose() {
    controller.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseTextFieldProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: courseState.length < 50
                ? AppColorsTheme.main().gfGray100Color
                : AppColorsTheme.main().gfWarningBackGroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            onChanged: (value) {
              ref.read(courseTextFieldProvider.notifier).setKeyword(value);
            },
            decoration: InputDecoration(
              hintText: '학습중이거나 학습완료 강좌 입력.',
              hintStyle: TextStyle(color: AppColorsTheme.main().gfGray400Color),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            style: AppTextsTheme.main().gfTitle2.copyWith(
                  color: AppColorsTheme.main().gfBlackColor,
                ),
          ),
        ),
        SizedBox(height: 8),
        courseState.length < 50
            ? Text('')
            : Text("강의명은 50자 미만으로 입력해주세요.",
          style: AppTextsTheme.main().gfTitle3.copyWith(
            color: AppColorsTheme.main().gfWarningColor,
          ),
        ),
      ],
    );
  }
}
