/// 用户实体
class UserEntity {
  const UserEntity({
    required this.userId,
    required this.userName,
    required this.token,
    required this.idCard,
  });

  final String userId;
  final String userName;
  final String token;
  final String idCard;
}
