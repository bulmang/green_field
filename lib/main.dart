import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

  await dotenv.load(fileName: 'assets/config/env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  KakaoSdk.init(
    nativeAppKey: dotenv.env['kakaoNativeAppKey'],
    javaScriptAppKey: dotenv.env['kakaoJavaScriptAppKey'],
  );

  if (kIsWeb) {
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

