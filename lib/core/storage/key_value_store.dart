abstract class KeyValueStore {
  Future<void> write({
    required String key,
    required String value,
  });

  Future<String?> read(String key);

  Future<void> delete(String key);
}
