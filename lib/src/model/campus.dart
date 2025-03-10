import 'package:green_field/src/utilities/design_system/app_icons.dart';

class Campus {
  String id;
  String name;
  List<String>? images;
  Map<String, dynamic> address;
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
      address: Map<String, String>.from(map['address']),
      operatingHours: map['operating_hours'] != null ? List<String>.from(map['operating_hours']) : null,
      contactNumber: map['contact_number'],
      floorDescription: map['floor_description'] != null
          ? Map<String, List<String>>.from(map['floor_description'].map(
            (key, value) => MapEntry(key, List<String>.from(value)),
      ))
          : null,
    );
  }
}

class CampusExample {
  Campus error = Campus(
      id: "001",
      name: "관악",
      images: ["https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/networkerror_sesac.png?alt=media"],
      address: {
        "CampusAddress" : "에러가 발생했어요!",
        "NaverMapURLScheme" : "https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/networkerror_sesac.png?alt=media",
        "NaverWebURL":"https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/networkerror_sesac.png?alt=media",
        "MapImageURL":"https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/networkerror_sesac.png?alt=media",
      },
      operatingHours: ["에러가 발생했어요!"],
      contactNumber: "",
    floorDescription: {
        "1층 (운영사무실, 라운지1, 파트너스페이스, 회의실, 잡코디룸)": ["https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/error.gif?alt=media&"],
      "2층 (집중학습룸: 플러터 개발, 라운지2)": ["https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/error.gif?alt=media&"],
      "3층 (클래스: 기획자)": ["https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/error.gif?alt=media&"],
      "4층 (옥상)": ["https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/error.gif?alt=media&"],
    }
  );
}
