import 'dart:math';

import 'package:web_learner/core/utils/esdt_encryption.dart';

/// 登录请求模型
class LoginRequest {
  const LoginRequest({
    required this.idCard,
    required this.password,
    this.openId = '',
    this.style = '0',
    this.auto = 'false',
  });

  /// 身份证号（原始值，未加密）
  final String idCard;

  /// 密码（原始值，未加密）
  final String password;

  /// 第三方登录 ID
  final String openId;

  /// 登录样式
  final String style;

  /// 自动登录标记
  final String auto;

  /// 转换为表单数据（application/x-www-form-urlencoded）
  Map<String, String> toFormData() {
    // 生成 1-18 的随机验证码
    final random = Random();
    final yzm = (random.nextInt(18) + 1).toString();

    return {
      'idcard': EsdtEncryption.encrypt(idCard),
      'pwd': EsdtEncryption.encrypt(password),
      'yzm': yzm,
      'openid': openId,
      'style': style,
      'auto': auto,
    };
  }
}
