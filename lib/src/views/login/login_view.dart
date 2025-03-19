import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/components/greenfield_loading_widget.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:lottie/lottie.dart';
import 'package:green_field/src/viewmodels/login/login_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cores/error_handler/result.dart';
import '../../utilities/design_system/app_colors.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/login_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

class LoginView extends ConsumerStatefulWidget {
  LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginNotifier = ref.watch(loginViewModelProvider.notifier);
    final userState = ref.watch(onboardingViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Text('새싹 수강생 커뮤니티, 풀밭',
                    style: AppTextsTheme.main()
                        .gfHeading1
                        .copyWith(color: Theme.of(context).appColors.gfMainColor)),

                Image.asset(
                  AppIcons.loginSesac,
                  width: 240,
                  height: 240,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 카카오 로그인 버튼
                    signInButton(
                      onPressed: () async {
                        final result = await ref
                            .read(loginViewModelProvider.notifier)
                            .signInWithKakao();

                        switch (result) {
                          case Success(value: final token):
                            final getUser = await ref
                                .read(onboardingViewModelProvider.notifier)
                                .isUserExistGetUser(token.providerUID);

                            switch (getUser) {
                              case Success(value: final user):
                                context.go('/home');
                              case Failure(exception: final e):
                                context.go('/onboarding');
                            }

                          case Failure(exception: final e):
                            print('error: $e');
                            loginNotifier.flutterToast('에러가 발생했어요!');
                        }
                      },
                      loginType: LoginType.kakao,
                    ),

                    SizedBox(height: 12),
                    // 애플 로그인 버튼

                    kIsWeb || (Platform.isAndroid)
                        ? SizedBox.shrink()
                        : signInButton(
                            onPressed: () async {

                              final result = await ref
                                  .read(loginViewModelProvider.notifier)
                                  .signInWithApple();

                              switch (result) {
                                case Success(value: final token):
                                  final getUser = await ref
                                      .read(onboardingViewModelProvider.notifier)
                                      .isUserExistGetUser(token.providerUID);

                                  switch (getUser) {
                                    case Success(value: final user):
                                      context.go('/home');
                                    case Failure(exception: final e):
                                      context.go('/onboarding');
                                  }

                                case Failure(exception: final e):
                                  loginNotifier.flutterToast('에러가 발생했어요!');
                              }
                            },
                            loginType: LoginType.apple,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          onPressed: () async {
                            final result = await ref
                                .read(loginViewModelProvider.notifier)
                                .signInWithAnonymously();

                            switch (result) {
                              case Success():
                              // context.go('/home');

                              case Failure(exception: final e):
                                loginNotifier.flutterToast('에러가 발생했어요!');
                            }

                          },
                          child: Text(
                            '로그인 없이 둘러보기',
                            style: AppTextsTheme.main().gfCaption1.copyWith(
                                color: Theme.of(context).appColors.gfGray400Color),
                          ),
                        ),
                        SizedBox(width: 10),
                        CupertinoButton(
                          onPressed: () async {
                              if (await canLaunch('https://open.kakao.com/o/sv8nyahh')) {
                                await launch('https://open.kakao.com/o/sv8nyahh');
                              } else {
                                throw 'Could not launch';
                              }
                          },
                          child: Text(
                            '문의하기',
                            style: AppTextsTheme.main().gfCaption1.copyWith(
                                color: Theme.of(context).appColors.gfGray400Color),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          loginState.isLoading || userState.isLoading
              ? GreenFieldLoadingWidget()
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

Widget signInButton({
  void Function()? onPressed,
  required LoginType loginType,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
    child: CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: loginType == LoginType.kakao
              ? const Color(0XFFFEE500)
              : AppColorsTheme.main().gfBlackColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                loginType == LoginType.kakao ? AppIcons.kakao : AppIcons.apple,
                width: 18,
                height: 18,
              ),
            ),
            Center(
              child: Text(
                loginType == LoginType.kakao ? '카카오로 시작하기' : 'Apple로 시작하기',
                style: AppTextsTheme.main().gfTitle1.copyWith(
                  color: loginType == LoginType.kakao
                      ? AppColorsTheme.main().gfBlackColor
                      : AppColorsTheme.main().gfWhiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
