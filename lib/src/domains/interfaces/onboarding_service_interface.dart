import '../../cores/error_handler/result.dart';
import '../../model/user.dart' as Client;

abstract class OnboardingServiceInterface {
  /// 사용자 생성
  Future<Result<Client.User, Exception>> createUserDB(Client.User user);

  /// 사용자 조회(ProviderID)
  Future<Result<Client.User, Exception>> getUserByProviderUID(String providerUID);

  /// 사용자 조회(UserID)
  Future<Result<Client.User?, Exception>> getUserById(String userId);
}
