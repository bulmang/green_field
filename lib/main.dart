import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/design_system/app_colors.dart';
import 'src/design_system/app_texts.dart';
import 'src/extensions/theme_data_extension.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '폰트, 색 사용 예시',
              style: Theme.of(context).appTexts.gfHeading1.copyWith(
                color: Theme.of(context).appColors.gfBlackColor
              )
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).appColors.gfMainBackGroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ...List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Heading ${index + 1}",
                        style: index == 0
                            ? Theme.of(context).appTexts.gfHeading1.copyWith(
                          color: Theme.of(context).appColors.gfMainColor,
                        )
                            : index == 1
                            ? Theme.of(context).appTexts.gfHeading2.copyWith(
                          color: Theme.of(context).appColors.gfBlueColor,
                        )
                            : Theme.of(context).appTexts.gfHeading3.copyWith(
                          color: Theme.of(context).appColors.gfWarningColor,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

