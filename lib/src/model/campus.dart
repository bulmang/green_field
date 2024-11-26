class Campus {
  String id;
  String name;
  List<String>? images;
  Map<String, String> address;
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

class CampusExample {
  Campus gwanack = Campus(
      id: "001",
      name: "관악캠퍼스",
      images: ['https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-11-21%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%204.47.19.png?alt=media&token=3bb33935-aceb-4cc8-b928-366762bef32d'],
      address: {
        "CampusAddress" : "서울 관악구 관악로 140",
        "NaverMapURLScheme" : "청년취업사관학교 관악캠퍼스",
        "NaverWebURL":"https://naver.me/GtU10L2p",
        "MapImageURL":"https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-11-21%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%204.47.19.png?alt=media&token=3bb33935-aceb-4cc8-b928-366762bef32d",
      },
      operatingHours: ["월요일 08:00~23:00", "화요일 08:00~23:00", "수요일 08:00~23:00", "목요일 08:00~23:00", "금요일 08:00~23:00", "토요일 08:00~23:00", "일요일 정기휴무(매주 일요일)"],
      contactNumber: "0507-1478-7960",
    floorDescription: {
        "1층 (운영사무실, 라운지1, 파트너스페이스, 회의실, 잡코디룸)": ["https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg", "https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg"],
      "2층 (집중학습룸: 플러터 개발, 라운지2)": ["https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg"],
      "3층 (클래스: 기획자)": ["https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg"],
      "4층 (옥상)": ["https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg","https://images.dog.ceo/breeds/spaniel-cocker/murphy.jpg"],
    }
  );
}
