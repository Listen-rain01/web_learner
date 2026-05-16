/// 表示可直接展示给用户的业务异常。
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
