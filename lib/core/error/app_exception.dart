/// 统一应用异常
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
