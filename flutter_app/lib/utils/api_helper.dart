import '../core/config/app_config.dart';

class ApiHelper {
  static String resolveUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${AppConfig.storageBaseUrl}$path';
  }
}
