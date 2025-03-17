import 'package:cloud_firestore/cloud_firestore.dart' as firebase_store;
import 'package:green_field/src/model/message.dart';

import '../../../cores/error_handler/result.dart';
import '../../../model/recruit.dart';
import '../../../model/report.dart';
import '../../../model/user.dart' as GFUser;

class FirebaseStoreChatService {
  FirebaseStoreChatService(this._store);

  final firebase_store.FirebaseFirestore _store;

  /// Message List 가져오기
  Future<Result<List<Message>, Exception>> getMessageList(String recruitId) async {
    try {
      final querySnapshot = await _store
          .collection('Recruit')
          .doc(recruitId)
          .collection('Message')
          .orderBy('created_at')
          .get();

      final comments = querySnapshot.docs.map((doc) {
        return Message.fromMap({
          ...doc.data(),
          'id': doc.id,
        });
      }).toList();

      return Success(comments);
    } catch (e) {
      print('err: $e');
      return Failure(Exception('메세지 목록 가져오기 실패: $e'));
    }
  }

  /// Stream을 이용하여 Message List 가져오기
  Stream<List<Message>> getMessageListStream(String recruitId) {
    return _store
        .collection('Recruit')
        .doc(recruitId)
        .collection('Message')
        .orderBy('created_at')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Message.fromMap({
          ...doc.data(),
          'id': doc.id,
        });
      }).toList();
    });
  }


  /// Message 생성
  Future<Result<Message, Exception>> createMessageDB(Recruit recruit, Message message) async {
    try {
      await _store
          .collection('Recruit')
          .doc(recruit.id)
          .collection('Message')
          .doc(message.id)
          .set(message.toMap());

      return Success(message);
    } catch (e) {
      print('err: $e');
      return Failure(Exception('댓글 생성 실패: $e'));
    }
  }

}