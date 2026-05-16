/// 定义应用内部使用的最小字符串键值存储契约。
abstract class KeyValueStore {
  /// 为指定 [key] 写入字符串 [value]。
  Future<void> write({
    required String key,
    required String value,
  });

  /// 读取 [key] 对应的字符串值。
  Future<String?> read(String key);

  /// 删除 [key] 对应的值。
  Future<void> delete(String key);
}
