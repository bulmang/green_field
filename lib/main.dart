import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_field/src/components/greenfield_comment_widget.dart';
import 'package:green_field/src/components/greenfield_content_widget.dart';
import 'package:green_field/src/components/greenfield_edit_section.dart';
import 'package:green_field/src/components/greenfield_recruit_list.dart';
import 'package:green_field/src/components/greenfield_text_field.dart';
import 'package:green_field/src/enums/feature_type.dart';
import 'package:green_field/src/model/notice.dart';
import 'package:green_field/src/model/recruit.dart';
import 'package:green_field/src/model/user.dart';
import 'package:green_field/src/views/home/home_view.dart';
import 'package:green_field/src/views/home/notice_view.dart';
import 'package:green_field/src/views/onboarding_view.dart';
import 'firebase_options.dart';
import 'package:green_field/src/components/greenfield_confirm_button.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_list.dart';
import 'package:green_field/src/components/greenfield_user_info_widget.dart';
import 'package:green_field/src/design_system/app_colors.dart';

import 'src/model/post.dart';
import 'src/views/login_view.dart';

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
      home: NoticeView(notice: [])
    );
  }
}
