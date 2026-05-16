import 'package:shared_preferences/shared_preferences.dart';

/// 封装 `SharedPreferences`，用于非敏感本地键值存储。
class LocalKvStore {
  LocalKvStore({Future<SharedPreferences>? preferencesFuture})
    : _preferencesFuture = preferencesFuture ?? SharedPreferences.getInstance(),
      _memory = null;

  LocalKvStore.memory([Map<String, String>? seed])
    : _memory = seed ?? <String, String>{},
      _preferencesFuture = null;

  final Future<SharedPreferences>? _preferencesFuture;
  final Map<String, String>? _memory;

  /// 向本地存储写入字符串值。
  Future<void> write({
    required String key,
    required String value,
  }) async {
    final memory = _memory;
    if (memory != null) {
      memory[key] = value;
      return;
    }

    final preferences = await _preferencesFuture!;
    await preferences.setString(key, value);
  }

  /// 从本地存储读取字符串值。
  Future<String?> read(String key) async {
    final memory = _memory;
    if (memory != null) {
      return memory[key];
    }

    final preferences = await _preferencesFuture!;
    return preferences.getString(key);
  }

  /// 从本地存储删除指定值。
  Future<void> delete(String key) async {
    final memory = _memory;
    if (memory != null) {
      memory.remove(key);
      return;
    }

    final preferences = await _preferencesFuture!;
    await preferences.remove(key);
  }
}
