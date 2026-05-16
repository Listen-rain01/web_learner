import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

/// 在应用支持目录中持久化后端会话 Cookie。
class SessionCookieStore {
  PersistCookieJar? _jar;

  /// 加载 Cookie 容器，并在进程内复用同一个实例。
  Future<PersistCookieJar> loadJar() async {
    final existingJar = _jar;
    if (existingJar != null) {
      return existingJar;
    }

    final supportDirectory = await getApplicationSupportDirectory();
    final cookieDirectory = Directory(
      '${supportDirectory.path}${Platform.pathSeparator}cookies',
    );

    if (!cookieDirectory.existsSync()) {
      cookieDirectory.createSync(recursive: true);
    }

    final jar = PersistCookieJar(
      storage: FileStorage(cookieDirectory.path),
    );
    _jar = jar;
    return jar;
  }

  /// 清空所有已持久化的会话 Cookie。
  Future<void> clear() async {
    final jar = await loadJar();
    await jar.deleteAll();
  }
}
