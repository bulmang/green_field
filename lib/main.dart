import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/components/greenfield_campus_picker.dart';
import 'package:green_field/src/components/greenfield_confirm_button.dart';
import 'package:green_field/src/design_system/app_colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        primaryColor: AppColorsTheme().gfMainColor,
        scaffoldBackgroundColor: AppColorsTheme().gfWhiteColor,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('GreenField Campus Picker'),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GreenFieldConfirmButton(
                text: "시작하기",
                isAble: false,
                textColor: AppColorsTheme().gfWhiteColor,
                backGroundColor: AppColorsTheme().gfMainColor,
                onPressed: () {
                  print("시작하기 버튼 클릭됨.");
                },
              ),
              const SizedBox(height: 20), // 버튼 간의 간격
              GreenFieldConfirmButton(
                text: "시작하기",
                isAble: true,
                textColor: AppColorsTheme().gfWhiteColor,
                backGroundColor: AppColorsTheme().gfMainColor,
                onPressed: () {
                  print("시작하기 버튼 클릭됨.");
                },
              ),
              const SizedBox(height: 20), // 버튼 간의 간격
              GreenFieldConfirmButton(
                text: "채팅으로 이야기 해보기",
                isAble: true,
                textColor: AppColorsTheme().gfMainColor,
                backGroundColor: AppColorsTheme().gfMainBackGroundColor,
                onPressed: () {
                  print("채팅으로 이야기 해보기 버튼 클릭됨.");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
