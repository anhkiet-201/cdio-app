import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityStorage {
  static final shared = SecurityStorage();
  final _storage = const FlutterSecureStorage();

  save({required String key, String? value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> get({required String key}) async {
    final result = await _storage.read(key: key, aOptions: _getAndroidOptions());
    return result;
  }

  Future<void> drop({required String key}) async {
    await _storage.delete(key: key, aOptions: _getAndroidOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}


