class Campus {
  String id;
  String name;
  List<String>? images;
  String address;
  List<String>? operatingHours;
  String contactNumber;
  Map<String, dynamic>? floorDescription;

  Campus({
    required this.id,
    required this.name,
    this.images,
    required this.address,
    this.operatingHours,
    required this.contactNumber,
    this.floorDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'images': images ?? [],
      'address': address,
      'operating_hours': operatingHours ?? [],
      'contact_number': contactNumber,
      'floor_description': floorDescription,
    };
  }

  static Campus fromMap(Map<String, dynamic> map) {
    return Campus(
      id: map['id'],
      name: map['name'],
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      address: map['address'],
      operatingHours: map['operating_hours'] != null ? List<String>.from(map['operating_hours']) : null,
      contactNumber: map['contact_number'],
      floorDescription: map['floor_description'] != null ? {
        'floor': map['floor_description']['floor'],
        'description': map['floor_description']['description'],
        'images': List<String>.from(map['floor_description']['images'] ?? []),
      } : null,
    );
  }
}
