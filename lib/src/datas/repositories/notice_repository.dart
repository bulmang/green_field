import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/cores/image_type/image_type.dart';
import 'package:image_picker/image_picker.dart';

import '../../cores/error_handler/result.dart';
import '../../model/notice.dart';
import '../../model/user.dart';
import '../services/firebase_storage_service.dart';
import '../services/firebase_store_service.dart';

class NoticeRepository {
  final FirebaseStoreService firebaseStoreService;
  final FirebaseStorageService firebaseStorageService;

  NoticeRepository({required this.firebaseStoreService, required this.firebaseStorageService});

  /// Notice 리스트 가져오기
  Future<Result<List<Notice>, Exception>> getNoticeList() async {
    try {
      final result = await firebaseStoreService.getNoticeList();

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

  /// Notice DB 생성
  Future<Result<Notice, Exception>> createNoticeDB(User user, Notice notice, List<ImageType>? images) async {
    try {
      final uploadImageResult = await uploadImage(user, images);

      switch(uploadImageResult) {
        case Success(value: final imageUrls):
          notice.images = imageUrls;
          final result = await firebaseStoreService.createNoticeDB(notice);

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

      final result = await firebaseStorageService.uploadImages(user, xFileImages);

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
    firebaseStoreService: FirebaseStoreService(FirebaseFirestore.instance),
    firebaseStorageService: FirebaseStorageService(FirebaseStorage.instance),
  );
});