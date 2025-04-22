
import 'package:green_field/src/datas/repositories/chat_repository.dart';
import 'package:green_field/src/model/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/post_repository.dart';
import '../../model/post.dart';
import '../../model/recruit.dart';
import '../../model/user.dart';

part 'chat_view_model.g.dart';

@Riverpod(keepAlive: true)
class ChatViewModel extends _$ChatViewModel {
  @override
  Future<List<Message>> build() async {
    return [];
  }

  /// 메시지 조회하기 (스트림 사용)
  Stream<List<Message>> getMessageListStream(String recruitId) {
    return ref.watch(chatRepositoryProvider).getMessageListStream(recruitId);
  }

  /// 새로운 메시지 생성
  Future<Result<Message, Exception>> createMessage(Recruit recruit, User user, String chatNickName, String messageText) async {
    try {

      final Uuid uuid = Uuid();
      final message = Message(
          id: uuid.v4(),
          roomId: recruit.id,
          userId: user.id,
          userName: chatNickName,
          text: messageText,
          createdAt: DateTime.now(),
      );

      final result = await ref
          .read(chatRepositoryProvider) // 댓글 추가 API 호출
          .createMessageDB(recruit, message);

      switch (result) {
        case Success(value: final comment):
          return Success(comment);

        case Failure(exception: final exception):
          state = AsyncError(exception, StackTrace.current);
          return Failure(Exception(exception));
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      return Failure(Exception('메세지 추가 실패: $error'));
    }
  }

}