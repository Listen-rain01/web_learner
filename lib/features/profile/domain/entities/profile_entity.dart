/// 个人基本信息实体
class ProfileEntity {
  const ProfileEntity({
    required this.pname,
    required this.idcard,
    required this.punit,
    required this.tel,
    required this.address,
    required this.photoUrl,
  });

  final String pname;
  final String idcard;
  final String punit;
  final String tel;
  final String address;

  /// 头像请求路径（相对路径，需拼接 baseUrl）
  final String photoUrl;
}
