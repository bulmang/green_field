import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_field/src/views/board/board_view.dart';
import 'package:green_field/src/views/main_view.dart';
import 'package:green_field/src/views/notice/notice_view.dart';
import 'firebase_options.dart';
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
        scaffoldBackgroundColor: AppColorsTheme().gfBackGroundColor,
      ),
      home: MainView()
    );
  }
}
