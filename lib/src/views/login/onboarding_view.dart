import 'package:flutter/material.dart';
import '../../utilities/components/greenfield_campus_picker.dart';
import '../../utilities/components/greenfield_confirm_button.dart';
import '../../utilities/design_system/app_colors.dart';
import '../../utilities/design_system/app_texts.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                            color: Theme.of(context).appColors.gfGray800Color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GreenFieldCampusPicker(),
                        const SizedBox(height: 20),
                        Text(
                          "학습 및 학습 완료 강좌",
                          style: AppTextsTheme.main().gfTitle3.copyWith(
                            color: Theme.of(context).appColors.gfGray800Color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        customTextField(onAction: (string) {}),
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
                isAble: true,
                textColor: Theme.of(context).appColors.gfWhiteColor,
                backGroundColor: Theme.of(context).appColors.gfMainColor,
                onPressed: () {
                  print("시작하기 버튼 클릭됨.");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customTextField({
  required Function(String) onAction,
  String? hintText,
}) {
  final TextEditingController controller = TextEditingController();

  return Container(
    decoration: BoxDecoration(
      color: AppColorsTheme.main().gfGray100Color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextField(
      controller: controller,
      onChanged: onAction,
      decoration: InputDecoration(
        hintText: hintText ?? '학습중이거나 학습완료 강좌 입력.',
        hintStyle: TextStyle(color: AppColorsTheme.main().gfGray400Color),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      style: AppTextsTheme.main().gfTitle2.copyWith(
        color: AppColorsTheme.main().gfBlackColor,
      ),
    ),
  );
}
