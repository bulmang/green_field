import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_field/src/components/greenfield_comment_widget.dart';
import 'package:green_field/src/components/greenfield_content_widget.dart';
import 'package:green_field/src/components/greenfield_text_field.dart';
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
        backgGroundColor: AppColorsTheme().gfWhiteColor,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            GreenFieldContentWidget(
                title: "제목 예시",
                bodyText:
                '''
안녕하세요 서울 경제 진흥원 관악캠퍼스 매니저입니다.
최근 식당 늘어난 걸 모르시는 분들이 많은 것 같다고 하셔서 (저도 몰랐네용) 홍보차 메세지 남깁니다!!
안녕하세요 서울 경제 진흥원 관악캠퍼스 매니저입니다. 최근 식당 늘어난 걸 모르시는 분들이 많은 것 같다고 하셔서 
(저도 몰랐네용) 홍보차 메세지 남깁니다!! 안녕하세요 서울 경제 진흥원 관악캠퍼스 매니저입니다. 
최근 식당 늘어난 걸 모르시는 분들이 많은 것 같다고 하셔서 (저도 몰랐네용) 홍보차 메세지 남깁니다!!안녕하세요 
서울 경제 진흥원 관악캠퍼스 매니저입니다. 최근 식당 늘어난 걸 모르시는 분들이 많은 것 같다고 하셔서 (저도 몰랐네용)
(저도 몰랐네용) 홍보차 메세지 남깁니다!! 안녕하세요 서울 경제 진흥원 관악캠퍼스 매니저입니다. 
최근 식당 늘어난 걸 모르시는 분들이 많은 것 같다고 하셔서 (저도 몰랐네용) 홍보차 메세지 남깁니다!!안녕하세요 
서울 경제 진흥원 관악캠퍼스 매니저입니다. 최근 식당 늘어난 걸 모르시는 분들이 많은 것 같다고 하셔서 (저도 몰랐네용) 
홍보차 메세지 남깁니다!!안녕하세요 서울 경제 진흥원 관악캠퍼스 매니저입니다. 최근 식당 늘어난 걸 모르시는 분들이 많은 것 같다고 하셔서
(저도 몰랐네용) 홍보차 메세지 남깁니다!!
(저도 몰랐네용) 홍보차 메세지 남깁니다!!
(저도 몰랐네용) 홍보차 메세지 남깁니다!!
(저도 몰랐네용) 홍보차 메세지 남깁니다!!'''
                ,
                imageAssets: [
                  "https://images.dog.ceo/breeds/spitz-japanese/beet-001.jpg"
                ],
              likes: 14,
              commentCount: 0,
            ),
            GreenFieldCommentWidget(
              campus: '관악캠퍼스',
              dateTime: DateTime.parse('2024-11-05 14:30:00'),
              comment: '저는 이렇게 하고 있습니다.저는 이렇게 하고 있습니다.저는 이렇게 하고 있습니다.저는 이렇게 하고 있습니다.',
            ),
            GreenFieldCommentWidget(
              campus: '관악캠퍼스',
              dateTime: DateTime.parse('2024-11-05 14:30:00'),
              comment: '저는 이렇게 하고 있습니다.저는 이렇게 하고 있습니다.저는 이렇게 하고 있습니다.저는 이렇게 하고 있습니다.',
            )
          ],
        ),
      ),
      bottomNavigationBar: GreenFieldTextField(
        type: TextFieldType.post,
        onAction: (text) {
          print('전송된 텍스트: $text');
        },
      ),
    );
  }
}