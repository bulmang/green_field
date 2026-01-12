import 'dart:typed_data';

class ImageMetadata {
  final Uint8List bytes;
  final int width;
  final int height;

  ImageMetadata({required this.bytes, required this.width, required this.height});

  double get aspectRatio => width / height;

}