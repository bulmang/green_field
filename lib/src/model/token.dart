class Token {
  String? provider;
  String? idToken;
  String? accessToken;

  Token({
  this.provider,
  this.idToken,
  this.accessToken,
  });

  static Token fromMap(Map<String, dynamic> map) {
    // null 체크 및 기본값 설정
    String provider = map['provider'];
    String idToken = map['id_token'];
    String accessToken = map['access_token'];

    return Token(
      provider: provider,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
