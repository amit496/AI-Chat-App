import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';
import 'auth_service.dart';

class FirebaseAuthService {
  FirebaseAuthService({AuthService? auth, FirebaseAuth? firebaseAuth})
      : _auth = auth ?? AuthService(),
        _firebaseAuth = firebaseAuth;

  final AuthService _auth;
  final FirebaseAuth? _firebaseAuth;

  static bool get isReady => DefaultFirebaseOptions.isConfigured;

  FirebaseAuth get _firebase {
    if (_firebaseAuth != null) return _firebaseAuth!;
    if (!isReady) {
      throw FirebaseAuthException(
        code: 'firebase-not-configured',
        message: 'Run flutterfire configure first.',
      );
    }
    return FirebaseAuth.instance;
  }

  String? _verificationId;

  Future<void> signInWithGoogle() async {
    final google = GoogleSignIn();
    final account = await google.signIn();
    if (account == null) {
      throw FirebaseAuthException(code: 'google-cancelled', message: 'Google sign-in cancelled.');
    }
    final googleAuth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _firebase.signInWithCredential(credential);
    if (result.user == null) {
      throw FirebaseAuthException(code: 'google-failed', message: 'Google sign-in failed.');
    }
    await _auth.firebaseSync(result.user!);
  }

  Future<void> sendOtp(String phone) async {
    final normalized = phone.startsWith('+') ? phone : '+91$phone';
    final completer = Completer<void>();

    await _firebase.verifyPhoneNumber(
      phoneNumber: normalized,
      verificationCompleted: (credential) async {
        final result = await _firebase.signInWithCredential(credential);
        if (result.user != null) await _auth.firebaseSync(result.user!);
        if (!completer.isCompleted) completer.complete();
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) {
          completer.completeError(
            FirebaseAuthException(code: e.code, message: e.message ?? 'OTP verification failed'),
          );
        }
      },
      codeSent: (verificationId, _) {
        _verificationId = verificationId;
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (verificationId) => _verificationId = verificationId,
      timeout: const Duration(seconds: 60),
    );

    return completer.future;
  }

  Future<void> verifyOtp(String smsCode) async {
    final id = _verificationId;
    if (id == null) {
      throw FirebaseAuthException(code: 'no-verification-id', message: 'Request OTP first.');
    }
    final credential = PhoneAuthProvider.credential(verificationId: id, smsCode: smsCode.trim());
    final result = await _firebase.signInWithCredential(credential);
    if (result.user == null) {
      throw FirebaseAuthException(code: 'otp-failed', message: 'Invalid OTP.');
    }
    await _auth.firebaseSync(result.user!);
  }
}
