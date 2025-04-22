import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    '';
import 'package:green_field/src/datas/services/firebase_stores/firebase_store_chat_service.dart';
import 'package:green_field/src/domains/interfaces/chat_service_interface.dart';
import 'package:green_field/src/model/message.dart';

import '../../cores/error_handler/result.dart';
import '../../model/recruit.dart';

class ChatRepository {
  final ChatServiceInterface service;

  ChatRepository({required this.service});

  /// 실시간 메시지 스트림 제공
  Stream<List<Message>> getMessageListStream(String recruitId) {
    return service.getMessageListStream(recruitId);
  }

  /// 특정 채팅방의 메시지 목록 조회
  Future<Result<List<Message>, Exception>> getMessageList(String recruitId) async {
    try {
      final result = await service.getMessageList(recruitId);

      switch(result) {
        case Success(value: final v):
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 새로운 메시지 생성
  Future<Result<Message, Exception>> createMessageDB(Recruit recruit, Message message) async {
    try {
      final result = await service.createMessageDB(recruit, message);

      switch (result) {
        case Success(value: final v):
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('신고 기능 실패: $error'));
    }
  }

}

/// ChatRepositoryProvider 생성
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    service: FirebaseStoreChatService(FirebaseFirestore.instance),
  );
});
