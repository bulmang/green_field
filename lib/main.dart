import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:green_field/src/router/router.dart';
import 'package:green_field/src/utilities/design_system/app_colors.dart';
import 'package:green_field/src/utilities/design_system/app_texts.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';

void main() async {
  // env 파일 읽기
  await dotenv.load(fileName: 'assets/config/.env');

  // Flutter 프레임워크가 초기화되기 전에 Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['kakaoNativeAppKey'],
    javaScriptAppKey: dotenv.env['kakaoJavaScriptAppKey'],
  );

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 구성 파일에서 내보낸 DefaultFirebaseOptions 객체 사용
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: Theme.of(context).copyWith(
        extensions: [
          AppColorsTheme.main(),
          AppTextsTheme.main(),
        ]
      )
    );
  }
}
