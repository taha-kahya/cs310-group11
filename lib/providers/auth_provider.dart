import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _currentUser = _auth.currentUser;

    _auth.authStateChanges().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // ---------------- LOGIN ----------------

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- SIGNUP ----------------

  Future<void> signup(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ---------------- LOGOUT ----------------

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ---------------- HELPERS ----------------

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Exception _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return Exception('Incorrect email or password.');

      case 'invalid-email':
        return Exception('Please enter a valid email address.');

      case 'email-already-in-use':
        return Exception('This email is already registered.');

      case 'weak-password':
        return Exception('Password is too weak.');

      case 'too-many-requests':
        return Exception(
          'Too many attempts. Please wait a moment and try again.',
        );

      case 'network-request-failed':
        return Exception(
          'Network error. Please check your internet connection.',
        );

      default:
        return Exception(
          'Login failed. Please check your credentials and try again.',
        );
    }
  }

}
