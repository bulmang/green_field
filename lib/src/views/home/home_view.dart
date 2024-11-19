import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/views/home/sections/expiring_soon_recruit_section.dart';
import 'package:intl/intl.dart';

import 'package:green_field/src/design_system/app_icons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_texts.dart';
import '../../model/notice.dart';
import '../../model/post.dart';
import '../../model/recruit.dart';
import '../../model/user.dart';
import 'sections/external_link_section.dart';
import 'sections/notice_carousel.dart';
import 'sections/top_liked_posts_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = User(id: "1", simpleLoginId: "kakao", campus: "관악", course: "course", name: "name");

    List<Post> posts = [
      Post(
        id: 'post_001',
        creatorId: 'user_123',
        creatorCampus: '관악캠퍼스',
        createdAt: DateTime.now(),
        title: '새로운 식당 오픈 안내',
        body: '새로운 식당 어부사시가 오픈했습니다. 많은 이용 부탁드립니다!',
        like: ['user_456', 'user_789'],
        images: ['https://example.com/image1.jpg'],
      ),
      Post(
        id: 'post_002',
        creatorId: 'user_456',
        creatorCampus: '관악캠퍼스',
        createdAt: DateTime.now().subtract(Duration(days: 1)), // 하루 전
        title: '학기 시작 안내',
        body: '이번 학기는 3월 1일부터 시작됩니다.',
        like: ['user_123'],
        images: ['https://example.com/image2.jpg'],
      ),
      Post(
        id: 'post_003',
        creatorId: 'user_789',
        creatorCampus: '관악캠퍼스',
        createdAt: DateTime.now().subtract(Duration(days: 2)), // 이틀 전
        title: '모임 공지',
        body: '다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.',
        like: ['user_123', 'user_456'],
        images: [],
      ),
    ];

    List<Recruit> recruits = [
      Recruit(
        id: 'recruit_001',
        creatorId: 'user_123',
        remainTime: 120, // 남은 시간 (초)
        currentParticipants: ['user_456', 'user_789'],
        maxParticipants: 10,
        creatorCampus: '관악캠퍼스',
        isEntryAvailable: true,
        isTimeExpired: false,
        title: '같이 쌀국수 먹으러 가실 분!',
        body: '오늘 점심메뉴로 같이 쌀국수 먹으러 가실 분 구합니다.',
        images: ['https://example.com/image1.jpg'],
        createdAt: DateTime.now(),
      ),
      Recruit(
        id: 'recruit_002',
        creatorId: 'user_456',
        remainTime: 60, // 남은 시간 (초)
        currentParticipants: ['user_123'],
        maxParticipants: 5,
        creatorCampus: '관악캠퍼스',
        isEntryAvailable: true,
        isTimeExpired: false,
        title: '모임 공지',
        body: '다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.',
        images: [],
        createdAt: DateTime.now().subtract(Duration(days: 1)), // 하루 전
      ),
      Recruit(
        id: 'recruit_003',
        creatorId: 'user_789',
        remainTime: 30, // 남은 시간 (초)
        currentParticipants: [],
        maxParticipants: 8,
        creatorCampus: '관악캠퍼스',
        isEntryAvailable: false,
        isTimeExpired: true,
        title: '스터디 모집',
        body: '이번 주 토요일에 스터디를 모집합니다.',
        images: ['https://example.com/image2.jpg'],
        createdAt: DateTime.now().subtract(Duration(days: 2)), // 이틀 전
      ),
    ];


    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppIcons.profile,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '익명(${user.campus})',
                              style: AppTextsTheme.main().gfTitle1.copyWith(
                                    color: AppColorsTheme().gfBlackColor,
                                  ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              user.course,
                              style: AppTextsTheme.main().gfBody5.copyWith(
                                    color: AppColorsTheme().gfGray400Color,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.campus} 공지사항',
                          style: AppTextsTheme.main().gfTitle2.copyWith(
                                color: AppColorsTheme().gfBlackColor,
                              ),
                        ),
                        SizedBox(height: 5),
                        NoticeCarousel(
                          notices: [
                            Notice(
                              id: '1',
                              creatorId: 'user_123',
                              userCampus: '관악캠퍼스',
                              title: '새로운 식당 오픈 안내 새로운 식당 오픈 안내',
                              body: '새로운 식당 어부사시가 오픈했습니다. 많은 이용 부탁드립니다!',
                              like: ['user_456', 'user_789'],
                              images: [
                                'https://images.dog.ceo/breeds/australian-kelpie/Resized_20200303_233358_108952253645051.jpg'
                              ],
                              createdAt: DateTime.now(),
                            ),
                            Notice(
                              id: '2',
                              creatorId: 'user_456',
                              userCampus: '관악캠퍼스',
                              title: '학기 시작 안내',
                              body: '이번 학기는 3월 1일부터 시작됩니다.',
                              like: ['user_123'],
                              images: [
                                'https://images.dog.ceo/breeds/australian-kelpie/Resized_20200303_233358_108952253645051.jpg'
                              ],
                              createdAt: DateTime.now(),
                            ),
                            Notice(
                              id: '3',
                              creatorId: 'user_456',
                              userCampus: '관악캠퍼스',
                              title: '학기 시작 안내안내안내안내안내안내안내안내안내안내',
                              body:
                                  '이번 학기는 3월 1일부터 시작됩니다.이번 학기는 3월 1일부터 시작됩니다.이번 학기는 3월 1일부터 시작됩니다.',
                              like: ['user_123'],
                              images: [],
                              createdAt: DateTime.now(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: ExternalLinkSection(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HOT 게시판',
                          style: AppTextsTheme.main().gfTitle2.copyWith(
                            color: AppColorsTheme().gfBlackColor,
                          ),
                        ),
                        SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TopLikedPostsSection(posts: posts),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  '곧 사라지는 실시간 모집글',
                  style: AppTextsTheme.main().gfTitle2.copyWith(
                    color: AppColorsTheme().gfBlackColor,
                  ),
                ),
              ),
              ExpiringSoonRecruitSection(recruits: recruits)
            ],
          ),
        ),
      ),
    );
  }
}
