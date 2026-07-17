class Token {
  final String token;
  final String expiry;

  Token({required this.token, required this.expiry});

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'token_expiry': expiry,
    };
  }
}
