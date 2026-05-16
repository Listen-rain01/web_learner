/// 保存记住账号功能使用的本地账号凭据。
class SavedAccountCredential {
  const SavedAccountCredential({
    required this.idCard,
    required this.password,
  });

  /// 从本地存储恢复记住的账号凭据。
  factory SavedAccountCredential.fromMap(Map<String, dynamic> map) {
    return SavedAccountCredential(
      idCard: map['idCard'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  final String idCard;
  final String password;

  /// 转换成可序列化的映射结构。
  Map<String, dynamic> toMap() {
    return {
      'idCard': idCard,
      'password': password,
    };
  }
}
