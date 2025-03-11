import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:green_field/src/cores/router/router.dart';
import 'package:green_field/constants.dart';
import 'package:green_field/src/utilities/design_system/app_colors.dart';
import 'package:green_field/src/utilities/design_system/app_texts.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  // env 파일 읽기
  await dotenv.load(fileName: 'assets/config/env');

  // Flutter 프레임워크가 초기화되기 전에 Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 구성 파일에서 내보낸 DefaultFirebaseOptions 객체 사용
  );

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['kakaoNativeAppKey'],
    javaScriptAppKey: dotenv.env['kakaoJavaScriptAppKey'],
  );

  if(kIsWeb) {
    usePathUrlStrategy();
    runApp(
      ProviderScope(
        child: MyAppForWeb(),
      ),
    );
  } else {
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
        routerConfig: ref.watch(goRouterProvider),
        title: '풀밭',
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context).copyWith(
        extensions: [
          AppColorsTheme.main(),
          AppTextsTheme.main(),
        ]
      )
    );
  }
}

class MyAppForWeb extends ConsumerWidget {
  const MyAppForWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterWebFrame(
      builder: (context) {
        return MaterialApp.router(
          routerConfig: ref.watch(goRouterProvider),
          title: '풀밭',
          debugShowCheckedModeBanner: false,
          theme: Theme.of(context).copyWith(
            extensions: [
              AppColorsTheme.main(),
              AppTextsTheme.main(),
            ],
          ),
          builder: (context, child) {
            return LayoutBuilder(builder: (context, constraints) {
              return Center(
                child: child,
              );
            });
          },
        );
      },
      maximumSize: Size(kMaxScreenWidth, kMinScreenHeight), // Maximum size
      enabled: kIsWeb, // default is enable, when disable content is full size
      backgroundColor: Colors.white, // Background color/white space
    );
  }
}

