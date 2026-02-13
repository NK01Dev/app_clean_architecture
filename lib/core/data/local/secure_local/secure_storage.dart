import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'flutter_secure_storage_provider.dart';
import 'isecure_storage.dart';
final secureStorageProvider=Provider<ISecureStorage>((ref){
  return SecureStorage(ref.watch(flutterSecureStorageProvider));
});
final class SecureStorage implements ISecureStorage {
  final FlutterSecureStorage _secureStorage;
  SecureStorage(this._secureStorage);
  @override
  Future<void> delete(String key) async {
    // TODO: implement delete
    try {
      return await _secureStorage.delete(key: key);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> read(String key) async {
    // TODO: implement read
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    // TODO: implement write
try {
  return await _secureStorage.write(key: key, value: value);
} catch (e) {
  rethrow;
}
  }
}
