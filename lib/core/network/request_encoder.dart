/// 定义老系统接口要求的字段编码方式。
enum RequestEncoding {
  plain,
  esdt,
  urlEncoded,
}

/// 按照应用对接的后端规则编码请求字段。
class AppRequestEncoder {
  const AppRequestEncoder();

  /// 根据指定的后端协议类型 [type] 编码 [value]。
  String encode(String value, {required RequestEncoding type}) {
    switch (type) {
      case RequestEncoding.plain:
        return value;
      case RequestEncoding.esdt:
        return esdt(value);
      case RequestEncoding.urlEncoded:
        return Uri.encodeQueryComponent(value);
    }
  }

  /// 把文本转换成老系统要求的 `Esdt` 载荷格式。
  ///
  /// 后端要求先拼接每个字符的十进制码点，再附带每段长度描述，
  /// 最终结果还必须保持 URL 编码。
  String esdt(String value) {
    final codes = value.runes.map((rune) => rune.toString()).toList();
    final joinedCodes = codes.join();
    final lengths = codes.map((code) => code.length).join(',');

    return Uri.encodeComponent('$joinedCodes^$lengths');
  }
}
