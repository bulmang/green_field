import '../../cores/error_handler/result.dart';
import '../../model/user.dart'as Client;

abstract class SettingServiceInterface {
  /// 사용자 데이터 삭제
  Future<Result<void, Exception>> deleteUserDB(String userId);

  /// 외부 링크 생성 (관리자 전용)
  Future<Result<String, Exception>> createExternalLink(
      Client.User user,
      String linkID,
      String linkDomainName
      );

  /// 외부 링크 조회
  Future<Result<String, Exception>> getExternalLink(
      Client.User user,
      String linkID
      );
}
