/// 用户实体
class UserEntity {
  const UserEntity({
    required this.userId,
    required this.userName,
    required this.token,
  });

  final String userId;
  final String userName;
  final String token;
}
