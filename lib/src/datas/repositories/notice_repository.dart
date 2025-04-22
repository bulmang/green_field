import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:green_field/src/cores/image_type/image_type.dart';
import 'package:green_field/src/datas/services/firebase_stores/firebase_store_notice_service.dart';
import 'package:green_field/src/domains/interfaces/notice_service_interface.dart';
import 'package:image_picker/image_picker.dart';

import '../../cores/error_handler/result.dart';
import '../../model/notice.dart';
import '../../model/user.dart';
import '../services/firebase_storage_service.dart';

class NoticeRepository {
  final NoticeServiceInterface service;
  final FirebaseStorageService firebaseStorageService;

  NoticeRepository({required this.service, required this.firebaseStorageService});

  /// 공지 글 목록 조회
  Future<Result<List<Notice>, Exception>> getNoticeList(User? user) async {
    try {
      final result = await service.getNoticeList(user);

      switch(result) {
        case Success(value: final noticeList):
          return Success(noticeList);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 공지 글 추가 목록(페이징) 조회
  Future<Result<List<Notice>, Exception>> getNextNoticeList(List<Notice>? lastNotice, User user) async {
    try {
      final result = await service.getNextNoticeList(lastNotice, user);

      switch(result) {
        case Success(value: final noticeList):
          return Success(noticeList);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 공지 글 생성
  Future<Result<Notice, Exception>> createNoticeDB(User user, Notice notice, List<ImageType>? images) async {
    try {
      final uploadImageResult = await uploadImage(user, images);

      switch(uploadImageResult) {
        case Success(value: final imageUrls):
          notice.images = imageUrls;
          final result = await service.createNoticeDB(notice, user);

          switch (result) {
            case Success(value: final notice):
              return Success(notice);
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

  /// 특정 공지 글 조회
  Future<Result<Notice, Exception>> getNotice(String noticeId, User user) async {
    try {
      final result = await service.getNotice(noticeId, user);

      switch(result) {
        case Success(value: final noticeId):
          return Success(noticeId);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } on Exception catch (error) {
      return Failure(error); // 예외 발생 시 실패 반환
    }
  }

  /// 공지 글 삭제
  Future<Result<void, Exception>> deleteNoticeDB(String noticeId, User user) async {
    try {
      final result = await service.deleteNoticeDB(noticeId, user);

      switch (result) {
        case Success():
          return Success(null);
        case Failure(exception: final exception):
          return Failure(exception);
      }
    } catch (error) {
      return Failure(Exception('공지사항 삭제 실패: $error'));
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

      final result = await firebaseStorageService.uploadImages(user, xFileImages, 'notices');

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

/// NoticeRepositoryProvider 생성
final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  return NoticeRepository(
    service: FirebaseStoreNoticeService(FirebaseFirestore.instance),
    firebaseStorageService: FirebaseStorageService(FirebaseStorage.instance),
  );
});