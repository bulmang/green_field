import '../../cores/error_handler/result.dart';
import '../../model/recruit.dart';
import '../../model/report.dart';
import '../../model/user.dart' as Client;

abstract class RecruitServiceInterface {
  /// 모집 글 목록 조회
  Future<Result<List<Recruit>, Exception>> getRecruitList();

  /// 모집 글 생성
  Future<Result<Recruit, Exception>> createRecruitDB(Recruit recruit, Client.User user);

  /// 종료된 모집 글 생성
  Future<Result<Recruit, Exception>> createDeadRecruitDB(Recruit recruit);

  /// 모집 글 데이터 이동 -> 종료된 모집 글
  Future<Result<void, Exception>> moveAndDeleteCollection(String recruitId);

  /// 특정 모집 글 조회
  Future<Result<Recruit, Exception>> getRecruit(String recruitId, Client.User user);

  /// 모집 글 채팅방 입장 처리
  Future<Result<Recruit, Exception>> entryRecruitRoom(String recruitId, String userId);

  /// 모집 글 채팅방 퇴장 처리
  Future<Result<Recruit, Exception>> outRecruitRoom(String recruitId, String userId);

  /// 모집 글 신고
  Future<Result<Recruit, Exception>> reportRecruit(String recruitId, String userId, String reason);

  /// 신고 데이터 생성
  Future<Result<void, Exception>> createReportDB(String? commentId, Report report);

  /// 모집 글 삭제
  Future<Result<void, Exception>> deleteRecruitDB(String recruitId, Client.User user);
}
