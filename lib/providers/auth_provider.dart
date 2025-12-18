import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _currentUser;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _currentUser = _auth.currentUser;

    _auth.authStateChanges().listen((user) {
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      throw _mapError(e);
    }
    _setLoading(false);
  }

  Future<void> signup(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      throw _mapError(e);
    }
    _setLoading(false);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Exception _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No account found with this email.');
      case 'wrong-password':
        return Exception('Incorrect password.');
      case 'email-already-in-use':
        return Exception('Email already in use.');
      case 'weak-password':
        return Exception('Password too weak.');
      case 'network-request-failed':
        return Exception('Network error.');
      default:
        return Exception('Authentication failed.');
    }
  }
}
