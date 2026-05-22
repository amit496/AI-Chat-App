import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

import '../constants/brand_config.dart';

class AppConfig {
  static const String appName = BrandConfig.appName;

  /// Override: `--dart-define=API_BASE_URL=http://10.0.2.2:8081/api`
  static const String _envApiUrl = String.fromEnvironment('API_BASE_URL');

  /// Must match `php artisan serve` port (default 8000, or `--port=8081`)
  static const int backendPort = 8000;

  static String get apiBaseUrl {
    if (_envApiUrl.isNotEmpty) return _envApiUrl;
    if (kIsWeb) return 'http://127.0.0.1:$backendPort/api';
    if (Platform.isAndroid) {
      // Android Emulator → host machine
      return 'http://10.0.2.2:$backendPort/api';
    }
    return 'http://127.0.0.1:$backendPort/api';
  }

  static String get storageBaseUrl {
    final base = apiBaseUrl.replaceAll(RegExp(r'/api/?$'), '');
    return '$base/storage/';
  }

  static bool get firebaseConfigured {
    return firebaseApiKey.isNotEmpty && !firebaseApiKey.startsWith('YOUR_');
  }

  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );
}
