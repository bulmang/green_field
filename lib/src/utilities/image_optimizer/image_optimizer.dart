import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:green_field/src/model/image_metadata.dart';
import 'package:image/image.dart' as img;
import 'package:green_field/src/cores/error_handler/result.dart';

/// 이미지 최적화 클래스
class ImageOptimizer {
  /// 이미지 데이터 리사이징 및 JPG 압축 메서드
  static Future<Result<ImageMetadata, Exception>> resizeAndCompress(
      Uint8List data, {
        required int targetWidth,
        int quality = 85,
      }) async {
    try {
      final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(data);
      final ui.ImageDescriptor descriptor = await ui.ImageDescriptor.encoded(buffer);

      final int targetHeight = (descriptor.height * targetWidth / descriptor.width).round();

      final ui.Codec codec = await descriptor.instantiateCodec(
        targetWidth: targetWidth,
        targetHeight: targetHeight,
      );

      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image resizedUiImage = frameInfo.image;

      final ByteData? byteData = await resizedUiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return Failure(Exception("ByteData 변환 실패"));

      final img.Image imageFromRaw = img.Image.fromBytes(
        width: resizedUiImage.width,
        height: resizedUiImage.height,
        bytes: byteData.buffer,
        order: img.ChannelOrder.rgba,
      );

      final Uint8List compressedData = Uint8List.fromList(
        img.encodeJpg(imageFromRaw, quality: quality),
      );

      return Success(ImageMetadata(
        bytes: compressedData,
        width: resizedUiImage.width,
        height: resizedUiImage.height,
      ));
    } catch (e) {
      debugPrint("Optimization Error: $e");
      return Failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
