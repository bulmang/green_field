import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/design_system/app_colors.dart';
import 'src/design_system/app_texts.dart';
import 'src/extensions/theme_data_extension.dart';
import 'src/design_system/app_icons.dart';

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
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColorsTheme().gfBlackColor),
          bodyMedium: TextStyle(color: AppColorsTheme().gfGray400Color),
        ),
        extensions: [
          AppColorsTheme(), // Add AppColorsTheme to ThemeData
          AppTextsTheme.main(), // Add AppTextsTheme to ThemeData
        ],
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page', style: TextStyle(color: Theme.of(context).appColors.gfWhiteColor)),
        backgroundColor: Theme.of(context).appColors.gfMainColor,
      ),
      body: Column(
        children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: IconTextWidget(
                    text: '폰트, 색 사용 예시',
                    iconPath: AppIcons.info, // 사용하고자 하는 아이콘 경로
                  ),
              )],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: IconTextWidget(
                  text: '폰트, 색 사용 예시',
                  iconPath: AppIcons.info, // 사용하고자 하는 아이콘 경로
                ),
              )],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: IconTextWidget(
                  text: '폰트, 색 사용 예시',
                  iconPath: AppIcons.info, // 사용하고자 하는 아이콘 경로
                ),
              )],
          ),
        )
    ]
      ),
    );
  }
}

class IconTextWidget extends StatelessWidget {
  final String text;
  final String iconPath;

  const IconTextWidget({
    super.key,
    required this.text,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 최대 너비 설정
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).appColors.gfMainBackGroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 10), // 아이콘과 텍스트 사이의 간격
          Expanded( // 텍스트가 남은 공간을 차지하도록 설정
            child: Text(
              text,
              style: Theme.of(context).appTexts.gfHeading1.copyWith(
                color: Theme.of(context).appColors.gfMainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
