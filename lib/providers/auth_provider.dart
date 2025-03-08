import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _idToken;
  Timer? _tokenRefreshTimer;

  AuthenticationProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (_user != null) {
        _refreshIdToken();
        _startTokenRefreshTimer();
      }
      notifyListeners();
    });
  }

  bool get isLoggedIn => _user != null;

  String? get idToken => _idToken;

  String? get userName => _user?.displayName ?? _user?.email;

  Future<void> _refreshIdToken() async {
    if (_user != null) {
      _idToken = await _user!.getIdToken(true);
      notifyListeners();
    }
  }

  Future<void> refreshIdTokenIfNeeded() async {
    if (_user != null) {
      bool shouldRefresh = true;
      try {
        await _user!.getIdTokenResult(true);
        shouldRefresh = false;
      } catch (e) {
        shouldRefresh = true;
      }
      if (shouldRefresh) {
        await _refreshIdToken();
      }
    }
  }

  void _startTokenRefreshTimer() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer.periodic(Duration(minutes: 55), (timer) {
      _refreshIdToken();
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _idToken = null;
    _tokenRefreshTimer?.cancel();
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _user = userCredential.user;
    await _refreshIdToken();
    _startTokenRefreshTimer();
  }

  Future<void> signUp(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _user = userCredential.user;
    await _refreshIdToken();
    _startTokenRefreshTimer();
  }
}
