import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/components/greenfield_app_bar.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/components/greenfield_user_info_widget.dart';
import '../../utilities/design_system/app_colors.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/feature_type.dart';
import '../../viewmodels/onboarding/onboarding_view_model.dart';

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingView> {

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfBackGroundColor, // 배경색 설정
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: "설정",
        leadingIcon: Icon(
          CupertinoIcons.xmark,
          color: Theme.of(context).appColors.gfGray400Color,
        ),
        leadingAction: () {
          context.pop();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text('닉네임'),
                  trailing: Text(onboardingState.value?.name ?? ('익명')),
                ),
                CupertinoListTile(
                  title: Text('캠퍼스'),
                  trailing: Text(onboardingState.value?.campus ?? ('익명')),
                ),
                CupertinoListTile(
                  title: Text('유형'),
                  trailing: Text(onboardingState.value?.userType ?? ('익명')),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text('사용약관'),
                  trailing: Icon(CupertinoIcons.chevron_forward, color: CupertinoColors.inactiveGray),
                  onTap: () {
                    _launchURL('https://bulmang.notion.site/1a0d2c07070480638ee3f48aff0adae3?pvs=73');
                  },
                ),
                CupertinoListTile(
                  title: Text('개인정보처리방침'),
                  trailing: Icon(CupertinoIcons.chevron_forward, color: CupertinoColors.inactiveGray),
                  onTap: () {
                    _launchURL('https://bulmang.notion.site/1a0d2c07070480329802f0ec3b59a76e');
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text('고객센터'),
                  trailing: Icon(CupertinoIcons.chevron_forward, color: CupertinoColors.inactiveGray),
                  onTap: () {
                    _launchURL('https://open.kakao.com/o/sv8nyahh');
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text('로그아웃'),
                  onTap: () {
                    _showIOSDialog(
                      context: context,
                      title: "로그아웃",
                      body: '정말 로그아웃할까요?',
                      onConfirm: () {

                      },
                    );
                  }
                ),
                CupertinoListTile(
                  title: Text(
                    '탈퇴하기',
                    style: TextStyle(color: CupertinoColors.systemRed),
                  ),
                  onTap: () {
                    _showIOSDialog(
                      context: context,
                      title: "회원 탈퇴",
                      body: '정말 탈퇴할까요?',
                      onConfirm: () {

                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showIOSDialog({
    required BuildContext context,
    required String title,
    required String body,
    required VoidCallback onConfirm,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            child: Text("취소", style: TextStyle(color: CupertinoColors.activeBlue),),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: Text("확인", style: TextStyle(color: CupertinoColors.systemRed),),
            onPressed: () {
              Navigator.pop(context); // 먼저 다이얼로그 닫기
              onConfirm(); // 콜백 실행
            },
          ),
        ],
      ),
    );
  }
}


