import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/design_system/app_colors.dart';
import 'package:green_field/src/design_system/app_icons.dart';
import 'package:green_field/src/design_system/app_texts.dart';
import 'package:green_field/src/enums/login_type.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                    .copyWith(color: AppColorsTheme().gfMainColor)),
            Image.asset(
              AppIcons.loginSesac,
              width: 240,
              height: 240,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                signInButton(
                    onPressed: () {},
                    loginType: LoginType.kakao
                ),

                SizedBox(height: 12),

                signInButton(onPressed: () {},
                    loginType: LoginType.apple
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      child: Text(
                        '로그인 없이 둘러보기',
                        style: AppTextsTheme.main()
                            .gfCaption1
                            .copyWith(color: AppColorsTheme().gfGray400Color),
                      ),
                    ),
                    SizedBox(width: 10),
                    CupertinoButton(
                        onPressed: () {

                        },
                        child: Text(
                          '문의하기',
                          style: AppTextsTheme.main().gfCaption1.copyWith(
                              color: AppColorsTheme().gfGray400Color),
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
              : AppColorsTheme().gfBlackColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                loginType == LoginType.kakao
                    ? AppIcons.kakao
                    : AppIcons.apple
                ,
                width: 18,
                height: 18,
              ),
            ),
            Center(
              child: Text(
                loginType == LoginType.kakao
                    ? '카카오로 시작하기'
                    : 'Apple로 시작하기'
                ,
                style: AppTextsTheme.main().gfTitle1.copyWith(
                      color: loginType == LoginType.kakao
                          ? AppColorsTheme().gfBlackColor
                          : AppColorsTheme().gfWhiteColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

