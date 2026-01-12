/// String 확장 메서드 모음
extension StringExtension on String {
  String toThumbnailPath({int width = 200, int height = 200}) {
    final int queryIndex = indexOf('?');
    String cleanPath = queryIndex == -1 ? this : substring(0, queryIndex);

    final int dotIndex = cleanPath.lastIndexOf('.');
    if (dotIndex == -1) return this;

    final String basePath = cleanPath.substring(0, dotIndex);

    const String extension = '.jpeg';

    return '${basePath}_${width}x$height$extension?alt=media';
  }
}
