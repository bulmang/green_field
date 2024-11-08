import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:green_field/src/design_system/app_icons.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_texts.dart';
import '../model/notice.dart';
import '../model/post.dart';
import '../model/user.dart';
import 'home/external_link_section.dart';
import 'home/notice_carousel.dart';
import 'home/top_liked_posts_section.dart';

class HomeView extends StatefulWidget {
  final User user;
  final Post post;

  const HomeView({super.key, required this.user, required this.post});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0; // 현재 선택된 탭 인덱스

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM/dd').format(widget.post.createdAt);
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
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
                            '익명(${widget.user.campus})',
                            style: AppTextsTheme.main().gfTitle1.copyWith(
                                  color: AppColorsTheme().gfBlackColor,
                                ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            widget.user.course,
                            style: AppTextsTheme.main().gfBody5.copyWith(
                                  color: AppColorsTheme().gfGray400Color,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.user.campus} 공지사항',
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
                ExternalLinkSection(),
                Column(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '곧 사라지는 실시간 모집글',
                      style: AppTextsTheme.main().gfTitle2.copyWith(
                            color: AppColorsTheme().gfBlackColor,
                          ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '같이 쌀국수 먹으러 가실 분!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text('오늘 점심메뉴로 같이 쌀국수 먹으러 가실 분구합니다.'),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16),
                              SizedBox(width: 4),
                              Text('10 min'),
                              SizedBox(width: 16),
                              Icon(Icons.group, size: 16),
                              SizedBox(width: 4),
                              Text('1 / 4'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '모집'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: '게시판'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: '캠퍼스'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
