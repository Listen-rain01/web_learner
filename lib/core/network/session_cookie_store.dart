import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class SessionCookieStore {
  PersistCookieJar? _jar;

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

  Future<void> clear() async {
    final jar = await loadJar();
    await jar.deleteAll();
  }
}
