import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 封装安全存储，用于保存敏感本地键值数据。
class SecureKvStore {
  SecureKvStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage(),
      _memory = null;

  SecureKvStore.memory([Map<String, String>? seed])
    : _memory = seed ?? <String, String>{},
      _storage = null;

  final FlutterSecureStorage? _storage;
  final Map<String, String>? _memory;

  /// 写入敏感字符串值。
  Future<void> write({
    required String key,
    required String value,
  }) async {
    final memory = _memory;
    if (memory != null) {
      memory[key] = value;
      return;
    }

    await _storage!.write(key: key, value: value);
  }

  /// 读取敏感字符串值。
  Future<String?> read(String key) async {
    final memory = _memory;
    if (memory != null) {
      return memory[key];
    }

    return _storage!.read(key: key);
  }

  /// 删除敏感字符串值。
  Future<void> delete(String key) async {
    final memory = _memory;
    if (memory != null) {
      memory.remove(key);
      return;
    }

    await _storage!.delete(key: key);
  }
}
