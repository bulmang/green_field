/// 이미지의 너비가 높이보다 큰지 확인하는 클래스
class ImageDimensionParser {
  /// 싱글톤 패턴
  ImageDimensionParser._privateConstructor();

  /// 싱글톤 인스턴스
  static final ImageDimensionParser _instance =
      ImageDimensionParser._privateConstructor();

  /// 싱글톤 패턴
  factory ImageDimensionParser() {
    return _instance;
  }

  /// 이미지의 너비가 높이보다 큰지 확인하는 메서드
  bool isWidthSizeBiggerThanHeight(String? imageUrl) {
    if (imageUrl == null) return true;

    RegExp regExp = RegExp(r'width=(\d+)xheight=(\d+)');
    Match? match = regExp.firstMatch(imageUrl);

    if (match != null) {
      int width = int.parse(match.group(1)!);
      int height = int.parse(match.group(2)!);

      if (width > height) {
        return false;
      }
    }

    return true;
  }
}
