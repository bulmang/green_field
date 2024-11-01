import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
        scaffoldBackgroundColor: AppColorsTheme().gfWhiteColor,
      ),
      home: SamplePage(),
    );
  }
}

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GreenFieldAppBar(
        backgGroundColor: AppColorsTheme().gfBackGroundColor,
        title: '컴포넌트',
        leading: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child:  const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.grey,
          ),
        ),
        actions: [
          CupertinoButton(
            onPressed: () {
            },
            child:  const Icon(
              Icons.menu,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: ListView(
        children: List.generate(10, (index) {
          return GreenFieldList(
            title: '공지사항 1 $index',
            content: '새로운 식당 어부사시가 추가되었습니다. 진짜 정말 많은 많은 많은 이용 부탁...',
            date: '10/14',
            campus: '관악캠퍼스',
            imageUrl: 'https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20190827_233%2F1566877550770bS2af_JPEG%2Fyye_95qZkmqAYBf6_CK96hVs.jpeg.jpg',
            likes: 15,
            commentCount: 0,
            onTap: () {
              // 클릭 시 실행할 액션
              print('Item $index clicked');
            },
          );
        }),
      ),
    );
  }
}