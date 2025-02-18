import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:green_field/src/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../../model/notice.dart';

class FirebaseStorageService {
  FirebaseStorageService(this._storage);

  final FirebaseStorage _storage;

  /// 이미지 리스트를 Firebase Storage에 업로드
  Future<Result<List<String>?, Exception>> uploadImages(User user, List<XFile>? images) async {
    print('이미지 업로드 서비스 실행');
    try {
      List<String>? downloadURLS = [];
      for (var image in images!) {
        Uint8List bytes = await image.readAsBytes();
        // Decode the image to get its dimensions
        final ui.Codec codec = await ui.instantiateImageCodec(bytes);
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        final int width = frameInfo.image.width;
        final int height = frameInfo.image.height;

        List<int>? compressedBytes = await FlutterImageCompress.compressWithList(
          bytes,
          quality: 80,
        );

        if (compressedBytes != null) {
          String fileName = '${DateTime.now().millisecondsSinceEpoch}_width=${width}_height=${height}.jpg';
          Reference storageRef = _storage.ref().child("images/notices/${user.campus}/$fileName");
          UploadTask uploadTask = storageRef.putData(Uint8List.fromList(compressedBytes), SettableMetadata(contentType: 'image/jpeg'));

          TaskSnapshot snapshot = await uploadTask;

          String downloadURL = await snapshot.ref.getDownloadURL();
          downloadURLS.add(downloadURL);
        }
      }

      return Success(downloadURLS); // 업로드된 이미지 URL 리스트 반환
    } catch (e) {
      print(e);
      return Failure(Exception('이미지 업로드 실패: $e'));
    }
  }
}