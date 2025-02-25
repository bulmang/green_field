import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/components/greenfield_app_bar.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/setting/setting_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cores/error_handler/result.dart';
import '../../utilities/components/greenfield_loading_widget.dart';
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
    final userState = ref.watch(onboardingViewModelProvider);
    final settingState = ref.watch(settingViewModelProvider);

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
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10),
                CupertinoListSection.insetGrouped(
                  children: [
                    CupertinoListTile(
                      leading: Icon(CupertinoIcons.person_crop_rectangle),
                      title: Text('닉네임'),
                      trailing: Text(userState.value?.name ?? ('익명')),
                    ),
                    CupertinoListTile(
                      leading: Image.asset(
                        color: Theme.of(context).appColors.gfMainColor,
                        AppIcons.sesac,
                        width: 24,
                        height: 24,
                      ),
                      title: Text('캠퍼스'),
                      trailing: Text(userState.value?.campus ?? ('익명')),
                    ),
                    CupertinoListTile(
                      leading: Icon(CupertinoIcons.tag),
                      title: Text('유형'),
                      trailing: Text(userState.value?.userType ?? ('익명')),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    CupertinoListTile(
                      leading: Icon(CupertinoIcons.doc_plaintext),
                      title: Text('사용약관'),
                      trailing: Icon(CupertinoIcons.chevron_forward, color: CupertinoColors.inactiveGray),
                      onTap: () {
                        _launchURL('https://bulmang.notion.site/1a0d2c07070480638ee3f48aff0adae3?pvs=73');
                      },
                    ),
                    CupertinoListTile(
                      leading: Icon(CupertinoIcons.doc_person),
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
                      leading: Icon(CupertinoIcons.exclamationmark_bubble),
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
                    userState.value != null
                      ? CupertinoListTile(
                        leading: Icon(CupertinoIcons.square_arrow_left),
                      title: Text('로그아웃'),
                      onTap: () {
                        _showIOSDialog(
                          context: context,
                          title: "로그아웃",
                          body: '정말 로그아웃할까요?',
                          onConfirm: () async {
                            final reset = await ref
                                .read(onboardingViewModelProvider.notifier)
                                .resetUserState();

                            switch (reset) {
                              case Success():
                                final result = await ref
                                    .read(settingViewModelProvider.notifier)
                                    .signOut();

                                switch (result) {
                                  case Success():
                                    context.go('/signIn');

                                  case Failure(exception: final e):
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('로그아웃 실패'),
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

                              case Failure(exception: final e):
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('로그아웃 실패'),
                                    content: Text('에러 발생: $e'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text('확인'),
                                      ),
                                    ],
                                  ),
                                );
                                break;
                            }
                          },
                        );
                      }
                    )
                      : CupertinoListTile(
                        leading: Icon(CupertinoIcons.square_arrow_right),
                        title: Text('로그인 하러 가기'),
                        onTap: () async {
                              final reset = await ref
                                  .read(settingViewModelProvider.notifier)
                                  .resetUser();

                              switch (reset) {
                                case Success():
                                  context.go('/signIn');

                                case Failure(exception: final e):
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('익명 로그인 초기화 실패'),
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

                        }
                    ),
                    userState.value != null
                        ? CupertinoListTile(
                            leading: Icon(CupertinoIcons.person_crop_circle_badge_xmark),
                            title: Text(
                              '탈퇴하기',
                              style: TextStyle(color: CupertinoColors.systemRed),
                            ),
                            onTap: () {
                              _showIOSDialog(
                                context: context,
                                title: "회원 탈퇴",
                                body: '정말 탈퇴할까요?',
                                onConfirm: () async {
                                  final result = await ref
                                      .read(settingViewModelProvider.notifier)
                                      .deleteUser(userState.value?.id ?? '');

                                  switch (result) {
                                    case Success():
                                      context.go('/signIn');

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
                              );
                            },
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ],
            ),
          ),
          settingState.isLoading
              ? GreenFieldLoadingWidget()
              : SizedBox.shrink(),
        ],
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


