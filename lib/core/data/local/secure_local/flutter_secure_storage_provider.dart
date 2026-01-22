

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  const androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );
const iosOption=IOSOptions(
  accessibility: KeychainAccessibility.first_unlock,
);
  return FlutterSecureStorage(
    aOptions: androidOptions,
    iOptions: iosOption,
  );



});