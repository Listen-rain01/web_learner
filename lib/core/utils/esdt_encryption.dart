/// Esdt 加密工具类
/// 用于对身份证号和密码进行加密
class EsdtEncryption {
  EsdtEncryption._();

  /// Esdt 加密算法
  ///
  /// 加密步骤：
  /// 1. 获取每个字符的 ASCII 码值
  /// 2. 连接所有 ASCII 码值
  /// 3. 记录每个 ASCII 码的位数
  /// 4. 组合格式：[ASCII序列]^[长度序列]
  /// 5. 对结果进行 URL 编码
  ///
  /// 示例：
  /// - 输入："123"
  /// - ASCII 序列："495051" (49, 50, 51)
  /// - 长度序列："2,2,2"
  /// - 中间值："495051^2,2,2"
  /// - 最终编码："495051%5E2%2C2%2C2"
  static String encrypt(String input) {
    if (input.isEmpty) {
      return '';
    }

    // 1. 获取 ASCII 序列
    final asciiSequence = StringBuffer();
    final lengths = <int>[];

    for (int i = 0; i < input.length; i++) {
      final asciiCode = input.codeUnitAt(i);
      final asciiStr = asciiCode.toString();
      asciiSequence.write(asciiStr);
      lengths.add(asciiStr.length);
    }

    // 2. 组合格式：[ASCII序列]^[长度序列]
    final lengthSequence = lengths.join(',');
    final combined = '${asciiSequence.toString()}^$lengthSequence';

    // 3. URL 编码
    // ^ 编码为 %5E
    // , 编码为 %2C
    final encoded = Uri.encodeComponent(combined);

    return encoded;
  }

  /// 解密（用于测试验证）
  static String decrypt(String encoded) {
    // URL 解码
    final decoded = Uri.decodeComponent(encoded);

    // 分割 ASCII 序列和长度序列
    final parts = decoded.split('^');
    if (parts.length != 2) {
      throw FormatException('Invalid encrypted format');
    }

    final asciiSequence = parts[0];
    final lengths = parts[1].split(',').map(int.parse).toList();

    // 根据长度序列还原字符
    final result = StringBuffer();
    int index = 0;

    for (final length in lengths) {
      if (index + length > asciiSequence.length) {
        throw FormatException('Invalid length sequence');
      }

      final asciiStr = asciiSequence.substring(index, index + length);
      final asciiCode = int.parse(asciiStr);
      result.writeCharCode(asciiCode);
      index += length;
    }

    return result.toString();
  }
}
