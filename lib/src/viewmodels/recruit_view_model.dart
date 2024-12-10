import '../model/recruit.dart';

class RecruitViewModel {
  List<Recruit> recruits = [
    Recruit(
      id: '1',
      creatorId: 'user_001',
      remainTime: 60, // Remaining time in minutes (1 hour)
      currentParticipants: ['user_002', 'user_003'],
      maxParticipants: 4,
      creatorCampus: '캠퍼스 A',
      isEntryAvailable: true,
      isTimeExpired: false,
      title: '여름 인턴 모집',
      body: '여름 인턴을 모집합니다. 많은 지원 바랍니다.',
      images: [
        'https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg',
      ],
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Recruit(
      id: '2',
      creatorId: 'user_002',
      remainTime: 120, // Remaining time in minutes (2 hours)
      currentParticipants: [],
      maxParticipants: 4,
      creatorCampus: '캠퍼스 B',
      isEntryAvailable: true,
      isTimeExpired: false,
      title: '동아리 회원 모집',
      body: '우리 동아리에 가입하세요!',
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Recruit(
      id: '3',
      creatorId: 'user_003',
      remainTime: 30, // Remaining time in minutes (30 minutes)
      currentParticipants: ['user_004'], // Minimum 1 participant
      maxParticipants: 4,
      creatorCampus: '캠퍼스 C',
      isEntryAvailable: true,
      isTimeExpired: true, // Time expired because remainTime is less than 30 minutes
      title: '여름 캠프 참가자 모집',
      body: '여름 캠프에 참여할 학생을 모집합니다!',
      images: [],
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Recruit(
      id: '4',
      creatorId: 'user_004',
      remainTime: 90, // Remaining time in minutes (1 hour 30 minutes)
      currentParticipants: ['user_005', 'user_006'], // 2 participants
      maxParticipants: 4,
      creatorCampus: '캠퍼스 D',
      isEntryAvailable: true,
      isTimeExpired: false, // Time not expired
      title: '프로젝트 팀원 모집',
      body: '프로젝트 팀원을 모집합니다. 많은 지원 바랍니다.',
      images: [
        'https://images.dog.ceo/breeds/pitbull/dog-3981033_1280.jpg',
      ],
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Recruit(
      id: '5',
      creatorId: 'user_005',
      remainTime: 40, // Remaining time in minutes
      currentParticipants: ['user_007', 'user_008', 'user_009'], // 3 participants
      maxParticipants: 4,
      creatorCampus: '캠퍼스 E',
      isEntryAvailable: false, // Current participants equal to max participants
      isTimeExpired: false, // Time not expired
      title: '여름 방학 프로그램 모집',
      body: '여름 방학 프로그램에 참여할 학생을 모집합니다.',
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 3)),
    ),
    Recruit(
      id: '6',
      creatorId: 'user_006',
      remainTime: 60, // Remaining time in minutes
      currentParticipants: ['user_010', 'user_011', 'user_012', 'user_013'], // 4 participants
      maxParticipants: 4,
      creatorCampus: '캠퍼스 F',
      isEntryAvailable: false, // Current participants equal to max participants
      isTimeExpired: false, // Time not expired
      title: '여름 캠프 팀원 모집',
      body: '여름 캠프에 참여할 팀원을 모집합니다.',
      images: null,
      createdAt: DateTime.now().subtract(Duration(days: 4)),
    ),
  ];

  Recruit getRecruitById(String id) {
    return recruits.firstWhere((recruit) => recruit.id == id, orElse: () {
      throw Exception('Recruit not found');
    });
  }
}