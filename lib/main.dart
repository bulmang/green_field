import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_field/src/components/greenfield_comment_widget.dart';
import 'package:green_field/src/components/greenfield_content_widget.dart';
import 'package:green_field/src/components/greenfield_edit_section.dart';
import 'package:green_field/src/components/greenfield_recruit_list.dart';
import 'package:green_field/src/components/greenfield_text_field.dart';
import 'package:green_field/src/enums/feature_type.dart';
import 'package:green_field/src/model/recruit.dart';
import 'firebase_options.dart';
import 'package:green_field/src/components/greenfield_confirm_button.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_list.dart';
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
        scaffoldBackgroundColor: AppColorsTheme().gfBackGroundColor,
      ),
      home: SamplePage(),
    );
  }
}

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    Recruit recruit1 = Recruit(
      id: '1',
      creatorId: 'creator_001',
      remainTime: 60,
      currentParticipants: ['user_001', 'user_002'],
      maxParticipants: 10,
      creatorCampus: '서울 캠퍼스',
      isEntryAvailable: false,
      isTimeExpired: true,
      title: '축구 동아리 모집',
      body: '함께 축구를 즐길 동아리원을 모집합니다!',
      images: ['https://images.dog.ceo/breeds/pembroke/n02113023_209.jpg', 'https://images.dog.ceo/breeds/pembroke/n02113023_209.jpg'],
      createdAt: DateTime.now(),
    );

    // Recruit 인스턴스 2
    Recruit recruit2 = Recruit(
      id: '2',
      creatorId: 'creator_002',
      remainTime: 20,
      currentParticipants: ['user_003'],
      maxParticipants: 5,
      creatorCampus: '부산 캠퍼스',
      isEntryAvailable: false,
      isTimeExpired: false,
      title: '독서 모임',
      body: '책을 좋아하는 사람들과 함께 독서 모임을 가집니다.',
      images: ['https://images.dog.ceo/breeds/pembroke/n02113023_209.jpg', 'https://images.dog.ceo/breeds/pembroke/n02113023_209.jpg'],
      createdAt: DateTime.now().subtract(Duration(days: 1)), // 1일 전 생성
    );

    // Recruit 인스턴스 3
    Recruit recruit3 = Recruit(
      id: '3',
      creatorId: 'creator_003',
      remainTime: 30,
      currentParticipants: [],
      maxParticipants: 8,
      creatorCampus: '대구 캠퍼스',
      isEntryAvailable: true,
      isTimeExpired: true,
      title: '요가 클래스',
      body: '편안한 요가 클래스를 함께 하실 분을 모집합니다.',
      images: null, // 이미지 없음
      createdAt: DateTime.now().subtract(Duration(days: 2)), // 2일 전 생성
    );

    return Scaffold(
      appBar: GreenFieldAppBar(
        backgGroundColor: AppColorsTheme().gfWhiteColor,
        title: '컴포넌트',
        leading: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.grey,
          ),
        ),
        actions: [
          CupertinoButton(
            onPressed: () {},
            child: const Icon(
              Icons.menu,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GreenFieldRecruitList(recruits: recruit1),
              GreenFieldRecruitList(recruits: recruit2),
              GreenFieldRecruitList(recruits: recruit3),
            ],
          ),
        ),
      ),
    );
  }
}
