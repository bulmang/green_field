import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:green_field/src/utilities/image_optimizer/image_optimizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/model/user.dart';
import 'package:green_field/src/model/image_metadata.dart';

/// Firebase Storage와 연동하여 이미지 파일을 관리하는 서비스 클래스
class FirebaseStorageService {
  FirebaseStorageService(this._storage);
  final FirebaseStorage _storage;

  /// 이미지 업로드하고 저장된 경로의 URL 리스트 반환 메서드
  Future<Result<List<String>?, Exception>> uploadImages(
      User user, List<XFile>? images, String saveImagePath) async {
    try {
      if (images == null || images.isEmpty) return Success([]);

      List<String> downloadURLS = [];

      for (var image in images) {
        Uint8List originalBytes = await image.readAsBytes();

        final Result<ImageMetadata, Exception> optimizationResult =
            await ImageOptimizer.resizeAndCompress(
          originalBytes,
          targetWidth: 1024,
          quality: 80,
        );

        switch (optimizationResult) {
          case Success(value: final metadata):
            String fileName =
                '${DateTime.now().millisecondsSinceEpoch}_width=${metadata.width}xheight=${metadata.height}.jpg';
            Reference storageRef = _storage
                .ref()
                .child("images/$saveImagePath/${user.campus}/$fileName");

            UploadTask uploadTask = storageRef.putData(
              metadata.bytes,
              SettableMetadata(contentType: 'image/jpeg'),
            );

            TaskSnapshot snapshot = await uploadTask;
            String downloadURL = await snapshot.ref.getDownloadURL();
            downloadURLS.add(downloadURL);

          case Failure():
            continue;
        }
      }

      return Success(downloadURLS);
    } catch (e) {
      return Failure(Exception('전체 업로드 과정 중 예상치 못한 오류 발생: $e'));
    }
  }
}
