class ImageDimensionParser {
  // Private constructor
  ImageDimensionParser._privateConstructor();

  // Static instance
  static final ImageDimensionParser _instance = ImageDimensionParser._privateConstructor();

  // Factory constructor to return the same instance
  factory ImageDimensionParser() {
    return _instance;
  }

  // Method to parse dimensions and calculate scale factor
  double parseDimensions(String? imageUrl) {
    if (imageUrl == null) return 1.0; // Default scale if URL is null

    // Regular expression to match width and height
    RegExp regExp = RegExp(r'width=(\d+)_height=(\d+)');
    Match? match = regExp.firstMatch(imageUrl);

    if (match != null) {
      int width = int.parse(match.group(1)!);
      int height = int.parse(match.group(2)!);

      if (width > height) {
        double scaleFactor = width / height;
        double roundedScaleFactor = double.parse(scaleFactor.toStringAsFixed(1));
        return roundedScaleFactor + 0.15;
      }
    } else {
      print('No dimensions found.');
    }
    return 1.0;
  }
}
