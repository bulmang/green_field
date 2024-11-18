import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_list.dart';
import 'package:green_field/src/design_system/app_colors.dart';

import '../../model/notice.dart';
import 'notice_deatil_view.dart';

class NoticeView extends StatefulWidget {
  final List<Notice> notice;

  const NoticeView({super.key, required this.notice});

  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  final List<Notice> notices = [
    Notice(
      id: '1',
      creatorId: 'user_001',
      userCampus: '캠퍼스 A',
      title: '중식당 추가 안내',
      body: '안녕하세요 서울 경제 진흥원 관악캠퍼스 매니저입니다.최근 식당 늘어난 걸 모르시는 분들이 많은 것 같다고 하셔서 (저도 몰랐네용) 홍보차 메세지 남깁니다!![어부사시가] https://naver.me/GFYaoQhg[프랭크버거] https://naver.me/xgG2WAbh  아! 그리고 러닝메이트 식사는, 제로페이 가맹점 이용 건에 대해서 협의중이라 당분간은 (아마도 한 달.. 정도?) 장부 이용해야 할 것 같다고 첨언 주셨습니다!  다음 주 한 주도 건강하고 즐겁게 보내세요',
      like: ['user_002', 'user_003'],
      images: ['https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg','https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg','https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg'],
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Notice(
      id: '2',
      creatorId: 'user_002',
      userCampus: '캠퍼스 B',
      title: '공지사항 2',
      body: '공지사항 2의 내용입니다.',
      like: ['user_001'],
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Notice(
      id: '3',
      creatorId: 'user_003',
      userCampus: '캠퍼스 A',
      title: '공지사항 3',
      body: '공지사항 3의 내용입니다.',
      like: [],
      images: ['https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg'],
      createdAt: DateTime.now().subtract(Duration(days: 3)),
    ),
    Notice(
      id: '4',
      creatorId: 'user_004',
      userCampus: '캠퍼스 C',
      title: '공지사항 4',
      body: '공지사항 4의 내용입니다.',
      like: ['user_001', 'user_002', 'user_003'],
      images: ['https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg'],
      createdAt: DateTime.now().subtract(Duration(days: 4)),
    ),
    Notice(
      id: '5',
      creatorId: 'user_005',
      userCampus: '캠퍼스 B',
      title: '공지사항 5',
      body: '공지사항 5의 내용입니다.',
      like: ['user_006'],
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 5)),
    ),
    Notice(
      id: '6',
      creatorId: 'user_006',
      userCampus: '캠퍼스 A',
      title: '공지사항 6',
      body: '공지사항 6의 내용입니다.',
      like: ['user_001', 'user_005'],
      images: ['https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg'],
      createdAt: DateTime.now().subtract(Duration(days: 6)),
    ),
    Notice(
      id: '7',
      creatorId: 'user_007',
      userCampus: '캠퍼스 C',
      title: '공지사항 7',
      body: '공지사항 7의 내용입니다.',
      like: [],
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 7)),
    ),
    Notice(
      id: '8',
      creatorId: 'user_008',
      userCampus: '캠퍼스 A',
      title: '공지사항 8',
      body: '공지사항 8의 내용입니다.',
      like: ['user_002'],
      images: ['https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg'],
      createdAt: DateTime.now().subtract(Duration(days: 8)),
    ),
    Notice(
      id: '9',
      creatorId: 'user_009',
      userCampus: '캠퍼스 B',
      title: '공지사항 9',
      body: '공지사항 9의 내용입니다.',
      like: ['user_001', 'user_003'],
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 9)),
    ),
    Notice(
      id: '10',
      creatorId: 'user_010',
      userCampus: '캠퍼스 C',
      title: '공지사항 10',
      body: '공지사항 10의 내용입니다.',
      like: ['user_004'],
      images: ['https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg'],
      createdAt: DateTime.now().subtract(Duration(days: 10)),
    ),
    Notice(
      id: '11',
      creatorId: 'user_011',
      userCampus: '캠퍼스 A',
      title: '공지사항 11',
      body: '공지사항 11의 내용입니다.',
      like: ['user_002', 'user_005'],
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 11)),
    ),
    Notice(
      id: '12',
      creatorId: 'user_012',
      userCampus: '캠퍼스 B',
      title: '공지사항 12',
      body: '공지사항 12의 내용입니다.',
      like: [],
      images: ['https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg'],
      createdAt: DateTime.now().subtract(Duration(days: 12)),
    ),
    Notice(
      id: '13',
      creatorId: 'user_013',
      userCampus: '캠퍼스 C',
      title: '공지사항 13',
      body: '공지사항 13의 내용입니다.',
      like: ['user_001'],
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 13)),
    ),
    Notice(
      id: '14',
      creatorId: 'user_014',
      userCampus: '캠퍼스 A',
      title: '공지사항 14',
      body: '공지사항 14의 내용입니다.',
      like: ['user_003', 'user_006'],
      images: ['https://images.dog.ceo/breeds/boxer/n02108089_2831.jpg'],
      createdAt: DateTime.now().subtract(Duration(days: 14)),
    ),
    Notice(
      id: '15',
      creatorId: 'user_015',
      userCampus: '캠퍼스 B',
      title: '공지사항 15',
      body: '공지사항 15의 내용입니다.',
      like: [],
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 15)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme().gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: AppColorsTheme().gfWhiteColor,
        title: "공지사항",
        leadingIcon: SizedBox(),
      ),
      body: ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          final notice = notices[index];
          return GreenFieldList(
            title: notice.title,
            content: notice.body,
            date: '${notice.createdAt.year}-${notice.createdAt.month}-${notice.createdAt.day}',
            campus: notice.userCampus,
            imageUrl: notice.images != null && notice.images!.isNotEmpty ? notice.images![0] : "",
            likes: notice.like.length,
            commentCount: 0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoticeDetailView(notice: notice),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
