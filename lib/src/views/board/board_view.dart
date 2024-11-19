import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_list.dart';
import 'package:green_field/src/design_system/app_colors.dart';
import 'package:green_field/src/model/comment.dart';
import 'package:green_field/src/model/post.dart';
import 'package:green_field/src/views/board/board_detail_view.dart';
import '../../components/greenfield_tab_bar.dart';
import '../../design_system/app_texts.dart';
import '../notice/notice_deatil_view.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Post> posts = [
    Post(
      id: '1',
      creatorId: 'user_001',
      creatorCampus: '캠퍼스 A',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      title: '첫 번째 게시물첫 번째 게시물첫 번째 게시물첫 번째 게시물',
      body: '이것은 첫 번째 게시물의 내용입니다.',
      like: ['user_002', 'user_003'],
      images: [
        'https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg',
        'https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg',
        'https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg',
      ],
      comment: [
        Comment(
          id: '1',
          creatorId: 'user_001',
          creatorCampus: '캠퍼스 A',
          body: '이 게시물 정말 유익하네요! 감사합니다.',
          createdAt: DateTime.now().subtract(Duration(hours: 1)), // 1시간 전
        ),
        Comment(
          id: '2',
          creatorId: 'user_002',
          creatorCampus: '캠퍼스 B',
          body: '좋은 정보입니다. 더 많은 내용을 알고 싶어요.',
          createdAt: DateTime.now().subtract(Duration(hours: 2)), // 2시간 전
        ),
        Comment(
          id: '3',
          creatorId: 'user_003',
          creatorCampus: '캠퍼스 C',
          body: '이런 게시물이 더 많아졌으면 좋겠어요!',
          createdAt: DateTime.now().subtract(Duration(days: 1)), // 1일 전
        ),
        Comment(
          id: '4',
          creatorId: 'user_004',
          creatorCampus: '캠퍼스 A',
          body: '정말 흥미로운 주제입니다. 잘 읽었습니다!',
          createdAt: DateTime.now().subtract(Duration(days: 2)), // 2일 전
        ),
        Comment(
          id: '5',
          creatorId: 'user_005',
          creatorCampus: '캠퍼스 B',
          body: '감사합니다! 유용한 정보가 많네요.',
          createdAt: DateTime.now().subtract(Duration(days: 3)), // 3일 전
        ),
      ],
    ),
    Post(
      id: '2',
      creatorId: 'user_002',
      creatorCampus: '캠퍼스 B',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      title: '두 번째 게시물',
      body: '이것은 두 번째 게시물의 내용입니다.',
      like: ['user_001'],
      images: null,
      comment: [],
    ),
    Post(
      id: '3',
      creatorId: 'user_003',
      creatorCampus: '캠퍼스 A',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      title: '세 번째 게시물',
      body: '이것은 세 번째 게시물의 내용입니다.',
      like: [],
      images: ['https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg'],
      comment: [],
    ),
    Post(
      id: '4',
      creatorId: 'user_004',
      creatorCampus: '캠퍼스 C',
      createdAt: DateTime.now().subtract(Duration(days: 4)),
      title: '네 번째 게시물',
      body: '이것은 네 번째 게시물의 내용입니다.',
      like: ['user_001', 'user_002'],
      images: ['https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg'],
      comment: [],
    ),
    Post(
      id: '5',
      creatorId: 'user_005',
      creatorCampus: '캠퍼스 B',
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      title: '다섯 번째 게시물',
      body: '이것은 다섯 번째 게시물의 내용입니다.',
      like: ['user_006'],
      images: null,
      comment: [],
    ),
    Post(
      id: '6',
      creatorId: 'user_006',
      creatorCampus: '캠퍼스 A',
      createdAt: DateTime.now().subtract(Duration(days: 6)),
      title: '여섯 번째 게시물',
      body: '이것은 여섯 번째 게시물의 내용입니다.',
      like: ['user_001', 'user_005'],
      images: ['https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg'],
      comment: [],
    ),
    Post(
      id: '7',
      creatorId: 'user_007',
      creatorCampus: '캠퍼스 C',
      createdAt: DateTime.now().subtract(Duration(days: 7)),
      title: '일곱 번째 게시물',
      body: '이것은 일곱 번째 게시물의 내용입니다.',
      like: [],
      images: null,
      comment: [],
    ),
    Post(
      id: '8',
      creatorId: 'user_008',
      creatorCampus: '캠퍼스 A',
      createdAt: DateTime.now().subtract(Duration(days: 8)),
      title: '여덟 번째 게시물',
      body: '이것은 여덟 번째 게시물의 내용입니다.',
      like: ['user_002'],
      images: ['https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg'],
      comment: [],
    ),
    Post(
      id: '9',
      creatorId: 'user_009',
      creatorCampus: '캠퍼스 B',
      createdAt: DateTime.now().subtract(Duration(days: 9)),
      title: '아홉 번째 게시물',
      body: '이것은 아홉 번째 게시물의 내용입니다.',
      like: ['user_001', 'user_003'],
      images: null,
      comment: [],
    ),
    Post(
      id: '10',
      creatorId: 'user_010',
      creatorCampus: '캠퍼스 C',
      createdAt: DateTime.now().subtract(Duration(days: 10)),
      title: '열 번째 게시물',
      body: '이것은 열 번째 게시물의 내용입니다.',
      like: ['user_004'],
      images: ['https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg'],
      comment: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme().gfBackGroundColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: AppColorsTheme().gfBackGroundColor,
        title: "게시판",
        leadingIcon: SizedBox(),
        actions: [
          CupertinoButton(
              child: Icon(
                CupertinoIcons.square_pencil,
                size: 24,
                color: AppColorsTheme().gfGray400Color,
              ),
              onPressed: () {
                print("글쓰기 버튼 클릭");
              })
        ],
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return GreenFieldList(
              title: post.title,
              content: post.body,
              date:
                  '${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day}',
              campus: post.creatorCampus,
              imageUrl: post.images != null && post.images!.isNotEmpty
                  ? post.images![0]
                  : "",
              likes: post.like.length,
              commentCount: post.comment!.length ?? 0,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoardDetailView(post: post)),
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 20,
          left: MediaQuery.of(context).size.width / 2 - 60,
          child: CupertinoButton(
            onPressed: () {
              print("글쓰기 버튼 클릭");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF308F5B), Color(0xFF666666)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.pencil,
                    color: Colors.white,
                  ),
                  SizedBox(width: 3), // Space between icon and text
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0, right: 5),
                    child: Text(
                      '글 쓰기',
                      style: AppTextsTheme.main().gfCaption2.copyWith(
                            color: AppColorsTheme().gfWhiteColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
