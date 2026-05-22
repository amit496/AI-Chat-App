class AppConfig {
  static const String appName = 'NovaAI';

  /// Local Laravel API. Android emulator: `--dart-define=API_BASE_URL=http://10.0.2.2:8000/api`
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );

  static String get storageBaseUrl {
    final base = apiBaseUrl.replaceAll(RegExp(r'/api/?$'), '');
    return '$base/storage/';
  }

  static bool get firebaseConfigured {
    return firebaseApiKey.isNotEmpty &&
        !firebaseApiKey.startsWith('YOUR_');
  }

  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );
}
