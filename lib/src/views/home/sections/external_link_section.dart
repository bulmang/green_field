import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/viewmodels/setting/setting_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utilities/design_system/app_colors.dart';
import '../../../utilities/design_system/app_texts.dart';
import '../../../utilities/design_system/app_icons.dart';
import '../../../viewmodels/onboarding/onboarding_view_model.dart';

class ExternalLinkSection extends ConsumerStatefulWidget {

  const ExternalLinkSection({super.key});
  @override ExternalLinkSectionState createState() => ExternalLinkSectionState();
}

class ExternalLinkSectionState extends ConsumerState<ExternalLinkSection> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final settingNotifier = ref.read(settingViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          iconText(AppIcons.sesac, '새싹 홈', () {
            _launchURL('https://sesac.seoul.kr/');
          }),
          iconText(AppIcons.restaurant, '식당 안내', () async {
            if (userState.value != null) {
              final result = await ref.read(settingViewModelProvider.notifier)
                  .getExternalLink(userState.value!, '식당안내주소');

              switch (result) {
                case Success(value: final v):
                  _launchURL(v);
                case Failure(exception: final e):
                  settingNotifier.showToast('주소를 가져오지 못했습니다.\n캠퍼스 메니저님께 문의해주세요.');
              }
            }

          }),
          iconText(AppIcons.file, '강의 자료', () async {
            if (userState.value != null) {
              final result = await ref.read(settingViewModelProvider.notifier)
                  .getExternalLink(userState.value!, '강의자료주소');

              switch (result) {
                case Success(value: final v):
                  _launchURL(v);
                case Failure(exception: final e):
                  settingNotifier.showToast('주소를 가져오지 못했습니다.\n캠퍼스 메니저님께 문의해주세요.');
              }
            }
          }),
          iconText(AppIcons.discord, '디스코드', () async {
            if (userState.value != null) {
              final result = await ref.read(settingViewModelProvider.notifier)
                  .getExternalLink(userState.value!, '디스코드주소');

              switch (result) {
                case Success(value: final v):
                  _launchURL(v);
                case Failure(exception: final e):
                  settingNotifier.showToast('주소를 가져오지 못했습니다.\n캠퍼스 메니저님께 문의해주세요.');
              }
            }
          }),
        ],
      ),
    );
  }
  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Fluttertoast.showToast(
        msg: '주소가 잘못되었습니다\n캠퍼스 메니저님께 문의해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: AppColorsTheme.main().gfWarningColor,
        textColor: AppColorsTheme.main().gfWhiteColor,
        fontSize: 16.0,
      );
    }
  }

}

Widget iconText(String imagePath, String label, VoidCallback onPressed) {
  return CupertinoButton(
    padding: EdgeInsets.zero, // Remove default padding
    onPressed: onPressed,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 40,
          height: 40,
        ),
        SizedBox(height: 4), // Space between image and text
        Text(
          label,
          style: AppTextsTheme.main().gfCaption2.copyWith(
            color: AppColorsTheme.main().gfBlackColor,
          ),
        ),
      ],
    ),
  );
}
