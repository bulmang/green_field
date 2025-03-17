import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../cores/error_handler/result.dart';
import '../../cores/image_type/image_type.dart';
import '../../model/recruit.dart';
import '../../model/report.dart';
import '../../model/user.dart';
import '../services/firebase_stores/fireabase_store_recruit_service.dart';
import '../services/firebase_storage_service.dart';

class RecruitRepository {
  final FirebaseStoreRecruitService firebaseStoreService;
  final FirebaseStorageService firebaseStorageService;

  RecruitRepository({required this.firebaseStoreService, required this.firebaseStorageService});

  /// Recruit 리스트 가져오기
  Future<Result<List<Recruit>, Exception>> getRecruitList() async {
    try {
      final result = await firebaseStoreService.getRecruitList();

      switch(result) {
        case Success(value: final recruitList):
          // remainTime이 현재 시간보다 이전인 항목만 필터링
          final pastRecruits = recruitList.where((recruit) => !DateTime.now().isBefore(recruit.remainTime)).toList();

          for(var pastRecruit in pastRecruits) {
            final updateDeadRecruitResult = await createDeadRecruitDB(pastRecruit);
          }

          return Success(recruitList);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error);
    }
  }


  /// Recruit DB 생성
  Future<Result<Recruit, Exception>> createRecruitDB(User user, Recruit recruit, List<ImageType>? images) async {
    try {
      final uploadImageResult = await uploadImage(user, images);

      switch(uploadImageResult) {
        case Success(value: final imageUrls):
          recruit.images = imageUrls;
          final result = await firebaseStoreService.createRecruitDB(recruit, user);

          switch (result) {
            case Success(value: final post):
              return Success(post);
            case Failure(exception: final exception):
              return Failure(exception);
          }
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// Recruit DB 생성
  Future<Result<Recruit, Exception>> createDeadRecruitDB(Recruit recruit) async {
    try {
      final result = await firebaseStoreService.createDeadRecruitDB(recruit);

      switch (result) {
        case Success(value: final post):
          return Success(post);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 특정 Recruit 가져오기
  Future<Result<Recruit, Exception>> getRecruit(String recruitId, User user) async {
    try {
      final result = await firebaseStoreService.getRecruit(recruitId, user);

      switch(result) {
        case Success(value: final recruitId):
          return Success(recruitId);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 특정 Recruit Chat에 입장한 유저 추가
  Future<Result<Recruit, Exception>> entryChatRoom(String recruitId, String userId) async {
    try {
      final result = await firebaseStoreService.entryChatRoom(recruitId, userId);

      switch (result) {
        case Success(value: final v):
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('채팅방 입장 실패: $error'));
    }
  }

  /// 특정 Recruit Chat에 퇴장한 유저 삭제
  Future<Result<Recruit, Exception>> outChatRoom(String recruitId, String userId) async {
    try {
      final result = await firebaseStoreService.outChatRoom(recruitId, userId);

      switch (result) {
        case Success(value: final v):
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('채팅방 퇴장 실패: $error'));
    }
  }

  /// 특정 Recruit에 report 추가
  Future<Result<Recruit, Exception>> reportRecruit(String recruitId, String userId, String reason) async {
    try {
      final result = await firebaseStoreService.reportRecruit(recruitId, userId, reason);

      switch (result) {
        case Success(value: final v):
          await _createReport(recruitId, userId, reason);
          return Success(v);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('신고 기능 실패: $error'));
    }
  }

  /// Report 생성
  Future<Result<void, Exception>> _createReport(String recruitId, String userId, String reason) async {
    try {
      final Uuid uuid = Uuid();
      String reportID = uuid.v4();
      Report report;

        report = Report(id: reportID,
            type: reason,
            reportedTargetID: recruitId,
            reporterId: userId,
            createdAt: DateTime.now());


      final result = await firebaseStoreService.createReportDB(recruitId, report);

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

  /// Recruit 문서 삭제
  Future<Result<void, Exception>> deleteRecruitDB(String recruitId, User user) async {
    try {
      final result = await firebaseStoreService.deleteRecruitDB(recruitId, user);

      switch (result) {
        case Success():
          return Success(null);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('포스트 삭제 실패: $error'));
    }
  }

  /// Image 업로드 후 ImageURL 가져오기
  Future<Result<List<String>?, Exception>> uploadImage(User user, List<ImageType>? images) async {
    try {
      List<XFile> xFileImages = [];
      List<String> imageUrls = [];

      if (images != null ) {
        for (var image in images) {
          switch (image) {
            case XFileImage(: final value):
              xFileImages.add(value);
            case UrlImage(: final value):
              imageUrls.add(value);
          }
        }
      }

      final result = await firebaseStorageService.uploadImages(user, xFileImages, 'recruits');

      switch (result) {
        case Success(value: final value):
          imageUrls.addAll(value ?? []);
          return Success(imageUrls);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error);
    }
  }
}

final recruitRepositoryProvider = Provider<RecruitRepository>((ref) {
  return RecruitRepository(
    firebaseStoreService: FirebaseStoreRecruitService(FirebaseFirestore.instance),
    firebaseStorageService: FirebaseStorageService(FirebaseStorage.instance),
  );
});