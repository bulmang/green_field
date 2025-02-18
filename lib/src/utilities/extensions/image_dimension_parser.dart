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

      print('Width: $width');
      print('Height: $height');

      if (width > height) {
        // Calculate the scale factor based on the percentage difference
        double scaleFactor = width / height;
        double roundedScaleFactor = double.parse(scaleFactor.toStringAsFixed(1));
        print('Scale Factor: $roundedScaleFactor');
        return roundedScaleFactor + 0.0; // Return scale factor based on width-height ratio
      }
    } else {
      print('No dimensions found.');
    }
    return 1.0; // Default scale if no dimensions are found or width is not greater than height
  }
}
