import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, guest, error }

/// Tracks what type of feature a guest is trying to access
enum ProtectedFeature {
  toolkit,
  learning,
  ctf,
  community,
  report,
  profile,
  settings,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _status == AuthStatus.authenticated;
  bool get isGuest => _status == AuthStatus.guest;

  /// Guest user singleton
  static final UserModel _guestUser = UserModel(
    id: 'guest',
    name: 'Guest',
    email: 'guest@cyberlaw.app',
    passwordHash: '',
    score: 0,
    rank: 0,
    solvedChallenges: const [],
    avatarInitials: 'GT',
  );

  /// Hash a password using SHA-256 with a fixed app-level salt.
  String _hashPassword(String password) {
    const salt = 'cyberlawguardian_salt_v1';
    final bytes = utf8.encode('$salt$password');
    return sha256.convert(bytes).toString();
  }

  /// Restore session from Hive on app launch.
  Future<void> restoreSession() async {
    try {
      final sessionBox = await Hive.openBox(AppConstants.hiveBoxSession);
      final usersBox = await Hive.openBox(AppConstants.hiveBoxUsers);

      final savedEmail = sessionBox.get(AppConstants.sessionEmailKey) as String?;
      if (savedEmail != null && savedEmail.isNotEmpty) {
        final userData = usersBox.get(savedEmail);
        if (userData != null) {
          _currentUser = userData as UserModel;
          _status = AuthStatus.authenticated;
          notifyListeners();
          return;
        }
      }

      // Default to guest — no forced login
      _status = AuthStatus.guest;
      _currentUser = _guestUser;
      notifyListeners();
    } catch (_) {
      _status = AuthStatus.guest;
      _currentUser = _guestUser;
      notifyListeners();
    }
  }

  /// Enter guest mode
  void enterGuestMode() {
    _status = AuthStatus.guest;
    _currentUser = _guestUser;
    notifyListeners();
  }

  /// Login: validate against stored records.
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill in all fields';
      _status = AuthStatus.guest;
      notifyListeners();
      return false;
    }

    if (!email.contains('@')) {
      _errorMessage = 'Invalid email format';
      _status = AuthStatus.guest;
      notifyListeners();
      return false;
    }

    try {
      final usersBox = await Hive.openBox(AppConstants.hiveBoxUsers);
      final userData = usersBox.get(email.toLowerCase());

      if (userData == null) {
        _errorMessage = 'Email not registered. Please sign up first.';
        _status = AuthStatus.guest;
        notifyListeners();
        return false;
      }

      final user = userData as UserModel;
      final inputHash = _hashPassword(password);

      if (user.passwordHash != inputHash) {
        _errorMessage = 'Incorrect password. Please try again.';
        _status = AuthStatus.guest;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      _status = AuthStatus.authenticated;

      final sessionBox = await Hive.openBox(AppConstants.hiveBoxSession);
      await sessionBox.put(AppConstants.sessionEmailKey, email.toLowerCase());

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _status = AuthStatus.guest;
      notifyListeners();
      return false;
    }
  }

  /// Register: create and persist a user record in Hive.
  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'All fields are required';
      _status = AuthStatus.guest;
      notifyListeners();
      return false;
    }

    if (password.length < 8) {
      _errorMessage = 'Password must be at least 8 characters';
      _status = AuthStatus.guest;
      notifyListeners();
      return false;
    }

    try {
      final usersBox = await Hive.openBox(AppConstants.hiveBoxUsers);
      final normalizedEmail = email.toLowerCase();

      if (usersBox.containsKey(normalizedEmail)) {
        _errorMessage = 'Email already registered. Please log in.';
        _status = AuthStatus.guest;
        notifyListeners();
        return false;
      }

      final initials = name
          .split(' ')
          .take(2)
          .map((e) => e.isNotEmpty ? e[0] : '')
          .join()
          .toUpperCase();

      final newUser = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: normalizedEmail,
        passwordHash: _hashPassword(password),
        score: 0,
        rank: 99,
        solvedChallenges: const [],
        avatarInitials: initials.isEmpty ? '??' : initials,
      );

      await usersBox.put(normalizedEmail, newUser);

      _currentUser = newUser;
      _status = AuthStatus.authenticated;

      final sessionBox = await Hive.openBox(AppConstants.hiveBoxSession);
      await sessionBox.put(AppConstants.sessionEmailKey, normalizedEmail);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _status = AuthStatus.guest;
      notifyListeners();
      return false;
    }
  }

  /// Logout: clear session and return to guest mode.
  Future<void> logout() async {
    try {
      final sessionBox = await Hive.openBox(AppConstants.hiveBoxSession);
      await sessionBox.delete(AppConstants.sessionEmailKey);
    } catch (_) {}

    _currentUser = _guestUser;
    _status = AuthStatus.guest;
    notifyListeners();
  }

  /// Add score and persist
  Future<void> addScore(int points) async {
    if (!isLoggedIn || _currentUser == null) return;
    _currentUser = _currentUser!.copyWith(score: _currentUser!.score + points);
    await _persistCurrentUser();
    notifyListeners();
  }

  /// Mark a challenge as solved
  Future<void> markChallengeSolved(String challengeId, int points) async {
    if (!isLoggedIn || _currentUser == null) return;
    if (_currentUser!.solvedChallenges.contains(challengeId)) return;

    final updatedSolved = [..._currentUser!.solvedChallenges, challengeId];
    _currentUser = _currentUser!.copyWith(
      solvedChallenges: updatedSolved,
      score: _currentUser!.score + points,
    );
    await _persistCurrentUser();
    notifyListeners();
  }

  Future<void> _persistCurrentUser() async {
    if (_currentUser == null) return;
    try {
      final usersBox = await Hive.openBox(AppConstants.hiveBoxUsers);
      await usersBox.put(_currentUser!.email, _currentUser);
    } catch (_) {}
  }
}
