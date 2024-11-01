import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:green_field/src/components/greenfield_confirm_button.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_user_info_widget.dart';
import 'package:green_field/src/design_system/app_colors.dart';

void main() async {
  // Flutter 프레임워크가 초기화되기 전에 Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 구성 파일에서 내보낸 DefaultFirebaseOptions 객체 사용
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColorsTheme().gfMainColor,
        scaffoldBackgroundColor: AppColorsTheme().gfWhiteColor,
      ),
      home: SamplePage(),
    );
  }
}

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GreenFieldAppBar(
        backgGroundColor: AppColorsTheme().gfBackGroundColor,
        title: '컴포넌트',
        leading: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child:  const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.grey,
          ),
        ),
        actions: [
          CupertinoButton(
            onPressed: () {
            },
            child:  const Icon(
              Icons.menu,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GreenfieldUserInfoWidget(
              type: 'notice', // 타입 설정 (notice 또는 post)
              campus: '관악캠퍼스',
              createTimeText: '10/14 19:50',
            ),
            const SizedBox(height: 20), // 버튼 간의 간격
            GreenfieldUserInfoWidget(
              type: 'post', // 타입 설정 (notice 또는 post)
              campus: '관악캠퍼스',
              createTimeText: '10/14 19:50',
            ),
            const SizedBox(height: 20), // 버튼 간의 간격
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
    );
  }
}