import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/viewmodels/login_view_model.dart';
import 'package:green_field/src/viewmodels/user_view_model.dart';
import '../../cores/error_handler/result.dart';
import '../../datas/services/firebase_auth_service.dart';
import '../../utilities/design_system/app_colors.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/login_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final _auth = FirebaseAuthService();
  final _userVM = UserViewModel();
  final _loginVM = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('새싹 수강생 커뮤니티, 그린필드',
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
                signInButton(
                  onPressed: () async {
                    final result = await _loginVM.signInWithKakao();

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
                  loginType: LoginType.kakao,
                ),
                SizedBox(height: 12),
                signInButton(
                    onPressed: () async {
                      try {
                        await _auth.signInWithApple();
                        context.go('/home');
                      } catch (e) {
                        print('Error during Apple sign-in: $e');
                      }
                    },
                    loginType: LoginType.apple),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      child: Text(
                        '로그인 없이 둘러보기',
                        style: AppTextsTheme.main().gfCaption1.copyWith(
                            color: Theme.of(context).appColors.gfGray400Color),
                      ),
                    ),
                    SizedBox(width: 10),
                    CupertinoButton(
                        onPressed: () {},
                        child: Text(
                          '문의하기',
                          style: AppTextsTheme.main().gfCaption1.copyWith(
                              color:
                                  Theme.of(context).appColors.gfGray400Color),
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
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
