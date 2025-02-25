class Token {
  String provider;
  String providerUID;
  String idToken;
  String accessToken;

  Token({
  required this.provider,
  required this.providerUID,
  required this.idToken,
  required this.accessToken,
  });

  static Token fromMap(Map<String, dynamic> map) {
    // null 체크 및 기본값 설정
    String provider = map['provider'];
    String providerUID = map['providerUID'];
    String idToken = map['id_token'];
    String accessToken = map['access_token'];

    return Token(
      provider: provider,
      providerUID: providerUID,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
