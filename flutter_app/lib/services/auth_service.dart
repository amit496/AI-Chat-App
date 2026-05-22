import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';
import '../models/user_model.dart';
import '../utils/api_helper.dart';
import 'api_client.dart';
import 'storage_service.dart';

class AuthService {
  AuthService({
    ApiClient? api,
    StorageService? storage,
    FirebaseAuth? firebaseAuth,
  })  : _api = api ?? ApiClient(),
        _storage = storage ?? StorageService(),
        _firebaseAuth = firebaseAuth;

  final ApiClient _api;
  final StorageService _storage;
  final FirebaseAuth? _firebaseAuth;

  FirebaseAuth? get _firebase {
    if (_firebaseAuth != null) return _firebaseAuth;
    if (!DefaultFirebaseOptions.isConfigured) return null;
    return FirebaseAuth.instance;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? firebaseUid,
  }) async {
    final data = await _api.post('/register', auth: false, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (firebaseUid != null) 'firebase_uid': firebaseUid,
    });
    await _storage.saveToken(data['token'] as String);
    return _parseUser(data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.post('/login', auth: false, body: {
      'email': email,
      'password': password,
    });
    await _storage.saveToken(data['token'] as String);
    return _parseUser(data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> firebaseSync(User firebaseUser) async {
    final data = await _api.post('/auth/firebase-sync', auth: false, body: {
      'firebase_uid': firebaseUser.uid,
      'email': firebaseUser.email ?? '',
      'name': firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'User',
    });
    await _storage.saveToken(data['token'] as String);
    return _parseUser(data['user'] as Map<String, dynamic>);
  }

  Future<void> sendPasswordReset(String email) async {
    final fb = _firebase;
    if (fb == null) {
      throw StateError('Firebase is not configured. Use email/password login.');
    }
    await fb.sendPasswordResetEmail(email: email.trim());
  }

  Future<UserModel?> fetchProfile() async {
    final data = await _api.get('/profile');
    return _parseUser(data['user'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await _api.post('/logout');
    } catch (_) {}
    await _firebase?.signOut();
    await _storage.clearToken();
  }

  Future<String?> getToken() => _storage.getToken();

  UserModel _parseUser(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);
    if (copy['profile_image'] != null) {
      copy['profile_image'] = ApiHelper.resolveUrl(copy['profile_image'] as String?);
    }
    return UserModel.fromJson(copy);
  }
}
