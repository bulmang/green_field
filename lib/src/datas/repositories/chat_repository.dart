import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/cores/image_type/image_type.dart';
import 'package:green_field/src/datas/services/firebase_stores/firebase_store_chat_service.dart';
import 'package:green_field/src/model/comment.dart';
import 'package:green_field/src/model/message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../model/post.dart'; // Update model import
import '../../model/recruit.dart';
import '../../model/report.dart';
import '../../model/user.dart';
import '../services/firebase_storage_service.dart';
import '../services/firebase_stores/firebase_store_service.dart';

class ChatRepository { // Update class name
  final FirebaseStoreChatService firebaseStoreService;

  ChatRepository({required this.firebaseStoreService});

  /// Message List 스트림 가져오기
  Stream<List<Message>> getMessageListStream(String recruitId) {
    return firebaseStoreService.getMessageListStream(recruitId);
  }

  /// Message 리스트 가져오기
  Future<Result<List<Message>, Exception>> getMessageList(String recruitId) async {
    try {
      final result = await firebaseStoreService.getMessageList(recruitId);

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


  /// Message 생성
  Future<Result<Message, Exception>> createMessageDB(Recruit recruit, Message message) async {
    try {
      final result = await firebaseStoreService.createMessageDB(recruit, message);

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
    firebaseStoreService: FirebaseStoreChatService(FirebaseFirestore.instance),
  );
});
