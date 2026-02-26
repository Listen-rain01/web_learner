/// 表单验证工具类
class Validators {
  Validators._();

  /// 身份证号验证
  /// 支持 15 位和 18 位身份证号
  static String? idCard(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入身份证号';
    }

    // 移除空格
    final idCard = value.replaceAll(' ', '');

    // 长度检查
    if (idCard.length != 15 && idCard.length != 18) {
      return '身份证号长度应为 15 位或 18 位';
    }

    // 18 位身份证号验证
    if (idCard.length == 18) {
      // 前 17 位必须是数字，最后一位可以是数字或 X
      final pattern = RegExp(r'^\d{17}[\dXx]$');
      if (!pattern.hasMatch(idCard)) {
        return '身份证号格式不正确';
      }

      // 校验码验证
      if (!_validateIdCardChecksum(idCard)) {
        return '身份证号校验码错误';
      }
    } else {
      // 15 位身份证号必须全是数字
      final pattern = RegExp(r'^\d{15}$');
      if (!pattern.hasMatch(idCard)) {
        return '身份证号格式不正确';
      }
    }

    return null;
  }

  /// 密码验证
  /// 要求：6-20 位，至少包含字母和数字
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }

    if (value.length < 6) {
      return '密码长度不能少于 6 位';
    }

    if (value.length > 20) {
      return '密码长度不能超过 20 位';
    }

    // 检查是否包含字母和数字
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);

    if (!hasLetter || !hasDigit) {
      return '密码必须包含字母和数字';
    }

    return null;
  }

  /// 18 位身份证号校验码验证
  static bool _validateIdCardChecksum(String idCard) {
    // 加权因子
    const weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
    // 校验码对应值
    const checkCodes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];

    int sum = 0;
    for (int i = 0; i < 17; i++) {
      sum += int.parse(idCard[i]) * weights[i];
    }

    final checkCode = checkCodes[sum % 11];
    return idCard[17].toUpperCase() == checkCode;
  }
}
