import 'package:flutter/cupertino.dart';
import 'package:green_field/src/components/greenfield_campus_picker.dart';
import 'package:green_field/src/design_system/app_icons.dart';
import 'package:green_field/src/design_system/app_colors.dart';
import 'package:green_field/src/design_system/app_texts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        primaryColor: AppColorsTheme().gfMainColor,
        scaffoldBackgroundColor: AppColorsTheme().gfBackGroundColor,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: AppColorsTheme().gfBlackColor),
          actionTextStyle: TextStyle(color: AppColorsTheme().gfMainColor),
        ),
      ),
      home: Stack(
        children: [
          const HomePage(),
          const GreenFieldCampusPicker()
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Home Page'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconTextWidget(
                text: '폰트, 색 사용 예시',
                iconPath: AppIcons.info,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconTextWidget(
                text: '폰트, 색 사용 예시',
                iconPath: AppIcons.info,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconTextWidget(
                text: '폰트, 색 사용 예시',
                iconPath: AppIcons.info,
              ),
            ),
          ],
        ),
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
        color: AppColorsTheme().gfMainBackGroundColor,
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
              style: AppTextsTheme.main().gfHeading1.copyWith(
                color: AppColorsTheme().gfMainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
