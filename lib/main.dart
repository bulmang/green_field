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
      home: HomeView(
          user: User(
            id: '12345',
            simpleLoginId: 'user123',
            userType: 'student', // Optional, defaults to "student"
            campus: '관악캠퍼스',
            course: '컴퓨터공학',
            name: '홍길동',
            createDate: DateTime.now(), // Current date and time
            lastLoginDate: DateTime.now().subtract(Duration(days: 1)), // Last login was yesterday
          ),
        post: Post(
          id: 'post_001',
          creatorId: 'user_123',
          creatorCampus: '관악캠퍼스',
          createdAt: DateTime.now(), // 현재 날짜와 시간
          title: '새로운 식당 오픈 안내',
          body: '새로운 식당 어부사시가 오픈했습니다. 많은 이용 부탁드립니다!',
          like: ['user_456', 'user_789'], // 좋아요를 누른 사용자 ID 목록
          images: ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'], // 이미지 URL 목록
        )
      ),
    );
  }
}
