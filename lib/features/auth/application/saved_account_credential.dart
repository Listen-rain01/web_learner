class SavedAccountCredential {
  const SavedAccountCredential({
    required this.idCard,
    required this.password,
  });

  factory SavedAccountCredential.fromMap(Map<String, dynamic> map) {
    return SavedAccountCredential(
      idCard: map['idCard'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  final String idCard;
  final String password;

  Map<String, dynamic> toMap() {
    return {
      'idCard': idCard,
      'password': password,
    };
  }
}
