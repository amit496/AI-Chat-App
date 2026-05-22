import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../core/config/app_config.dart';
import '../models/user_model.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService}) : _auth = authService ?? AuthService();

  final AuthService _auth;

  UserModel? _user;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> bootstrap() async {
    _loading = true;
    notifyListeners();
    try {
      final token = await _auth.getToken();
      if (token != null) {
        _user = await _auth.fetchProfile();
      }
    } catch (_) {
      await _auth.logout();
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    return _run(() => _auth.login(email: email, password: password));
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String confirm,
  ) async {
    return _run(() => _auth.register(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: confirm,
        ));
  }

  Future<bool> loginWithFirebase() async {
    if (!AppConfig.firebaseConfigured) {
      _error = 'Add Firebase config (free Spark plan). See README.';
      notifyListeners();
      return false;
    }
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      _user = await _auth.firebaseSync(credential.user!);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'Authentication failed.';
      return false;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Something went wrong';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _auth.sendPasswordReset(email);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Something went wrong';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> _run(Future<UserModel> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await action();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Something went wrong';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.logout();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
