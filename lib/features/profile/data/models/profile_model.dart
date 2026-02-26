import 'dart:convert';

import '../../../../core/utils/esdt_encryption.dart';
import '../../domain/entities/profile_entity.dart';

/// 解析 MyBaseInfo 接口返回的 HTML 中的 vData JSON
class ProfileModel {
  const ProfileModel({
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
  final String photoUrl;

  /// 从 HTML 响应中提取 vData 并解析
  static ProfileModel fromHtml(String html) {
    final match = RegExp(
      r'var\s+vData\s*=\s*(\{.*?\});',
      dotAll: true,
    ).firstMatch(html);

    if (match == null) {
      throw Exception('无法解析个人信息响应');
    }

    final map = jsonDecode(match.group(1)!) as Map<String, dynamic>;

    final pid = map['pid'] as String? ?? '';
    final departmentId = map['DepartmentId'] as String? ?? '';
    final photoUrl = '/ArchiveManger/D_PersonManager/GetPersonPhoto'
        '?did=${EsdtEncryption.encrypt(departmentId)}'
        '&pid=${EsdtEncryption.encrypt(pid)}';

    return ProfileModel(
      pname: map['pname'] as String? ?? '',
      idcard: map['idcard'] as String? ?? '',
      punit: map['punit'] as String? ?? '',
      tel: map['tel'] as String? ?? '',
      address: map['address'] as String? ?? '',
      photoUrl: photoUrl,
    );
  }

  ProfileEntity toEntity() => ProfileEntity(
        pname: pname,
        idcard: idcard,
        punit: punit,
        tel: tel,
        address: address,
        photoUrl: photoUrl,
      );
}
