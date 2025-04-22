import '../../cores/error_handler/result.dart';
import '../../model/notice.dart';
import '../../model/user.dart' as Client;

abstract class NoticeServiceInterface {
  /// 공지 글 생성
  Future<Result<Notice, Exception>> createNoticeDB(Notice notice, Client.User user);

  /// 공지 글 삭제
  Future<Result<void, Exception>> deleteNoticeDB(String noticeId, Client.User user);

  /// 공지 글 수정
  Future<Result<Notice, Exception>> updateNoticeDB(Notice notice, Client.User user);

  /// 공지 글 목록 조회
  Future<Result<List<Notice>, Exception>> getNoticeList(Client.User? user);

  /// 공지 글 추가 목록(페이징) 조회
  Future<Result<List<Notice>, Exception>> getNextNoticeList(List<Notice>? lastNotice, Client.User user);

  /// 특정 공지 글 조회
  Future<Result<Notice, Exception>> getNotice(String noticeId, Client.User user);
}
