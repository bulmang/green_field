import '../model/post.dart';

class PostViewModel {
  List<Post> posts = [
    Post(
      id: 'post_001',
      creatorId: 'user_123',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now(),
      title: '새로운 식당 오픈 안내',
      body: '새로운 식당 어부사시가 오픈했습니다. 많은 이용 부탁드립니다!',
      like: ['user_456', 'user_789'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_002',
      creatorId: 'user_456',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 1)), // 하루 전
      title: '학기 시작 안내',
      body: '이번 학기는 3월 1일부터 시작됩니다.',
      like: ['user_123'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_003',
      creatorId: 'user_789',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 2)), // 이틀 전
      title: '모임 공지',
      body: '다음 주 금요일에 모임이 있습니다. 많은 참석 부탁드립니다.',
      like: ['user_123', 'user_456'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_004',
      creatorId: 'user_101',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 3)), // 사흘 전
      title: '여름 방학 프로그램 모집',
      body: '여름 방학 프로그램에 참여할 학생을 모집합니다.',
      like: [],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_005',
      creatorId: 'user_202',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 4)), // 나흘 전
      title: '신입 회원 모집',
      body: '우리 동아리에 가입하세요!',
      like: ['user_123'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_006',
      creatorId: 'user_303',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 5)), // 닷새 전
      title: '여름 캠프 참가자 모집',
      body: '여름 캠프에 참여할 학생을 모집합니다!',
      like: ['user_456'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_007',
      creatorId: 'user_404',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 6)), // 엿새 전
      title: '프로젝트 팀원 모집',
      body: '프로젝트 팀원을 모집합니다. 많은 지원 바랍니다.',
      like: [],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_008',
      creatorId: 'user_505',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 7)), // 일주일 전
      title: '여름 방학 프로그램 안내',
      body: '여름 방학 프로그램에 대한 안내입니다.',
      like: ['user_123', 'user_456'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_009',
      creatorId: 'user_606',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 8)), // 8일 전
      title: '동아리 활동 안내',
      body: '우리 동아리의 활동에 대해 알려드립니다.',
      like: ['user_789'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_010',
      creatorId: 'user_707',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 9)), // 9일 전
      title: '모임 일정 변경',
      body: '모임 일정이 변경되었습니다. 확인해주세요.',
      like: [],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_011',
      creatorId: 'user_808',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 10)), // 10일 전
      title: '신입생 환영회',
      body: '신입생 환영회에 많은 참석 바랍니다.',
      like: ['user_123'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_012',
      creatorId: 'user_909',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 11)), // 11일 전
      title: '여름 캠프 일정 안내',
      body: '여름 캠프 일정이 확정되었습니다.',
      like: ['user_456'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_013',
      creatorId: 'user_1010',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 12)), // 12일 전
      title: '동아리 모집 공고',
      body: '우리 동아리에 가입하세요!',
      like: [],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_014',
      creatorId: 'user_1111',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 13)), // 13일 전
      title: '여름 방학 프로그램 모집',
      body: '여름 방학 프로그램에 참여할 학생을 모집합니다.',
      like: ['user_123'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_015',
      creatorId: 'user_1212',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 14)), // 14일 전
      title: '신입 회원 모집',
      body: '우리 동아리에 가입하세요!',
      like: ['user_456','user_123', 'user_456','user_123'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_016',
      creatorId: 'user_1313',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 15)), // 15일 전
      title: '여름 캠프 참가자 모집',
      body: '여름 캠프에 참여할 학생을 모집합니다!',
      like: ['user_123', 'user_456','user_123', 'user_456'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
    Post(
      id: 'post_017',
      creatorId: 'user_1414',
      creatorCampus: '관악캠퍼스',
      createdAt: DateTime.now().subtract(Duration(days: 16)), // 16일 전
      title: '프로젝트 팀원 모집',
      body: '프로젝트 팀원을 모집합니다. 많은 지원 바랍니다.',
      like: ['user_123', 'user_456','user_123', 'user_456'],
      images: [
        'https://images.dog.ceo/breeds/danish-swedish-farmdog/ebba_001.jpg'
      ],
    ),
  ];

  Post getPostById(String id) {
    return posts.firstWhere((post) => post.id == id, orElse: () {
      throw Exception('Post not found');
    });
  }

  List<Post> getTopLikedPosts(int count) {
    List<Post> sortedPosts = List.from(posts);
    sortedPosts.sort((a, b) {
      int likeComparison = b.like.length.compareTo(a.like.length);
      if (likeComparison != 0) {
        return likeComparison;
      }
      return a.createdAt.compareTo(b.createdAt);
    });
    return sortedPosts.take(count).toList();
  }
}
