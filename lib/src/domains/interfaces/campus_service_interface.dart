import '../../cores/error_handler/result.dart';
import '../../model/campus.dart';

abstract class CampusServiceInterface {
  /// 캠퍼스 생성
  Future<Result<Campus, Exception>> createCampusDB(Campus campus);

  /// 캠퍼스 조회
  Future<Result<Campus, Exception>> getCampus(String campusName);
}
