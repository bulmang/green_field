import '../../cores/error_handler/result.dart';
import '../../model/message.dart';
import '../../model/recruit.dart';

abstract class ChatServiceInterface {
  /// 특정 채팅방의 메시지 목록 조회
  Future<Result<List<Message>, Exception>> getMessageList(String recruitId);

  /// 실시간 메시지 스트림 제공
  Stream<List<Message>> getMessageListStream(String recruitId);

  /// 새로운 메시지 생성
  Future<Result<Message, Exception>> createMessageDB(Recruit recruit, Message message);
}
