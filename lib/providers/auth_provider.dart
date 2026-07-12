import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _status == AuthStatus.authenticated;

  /// Hash a password using SHA-256 with a fixed app-level salt.
  /// We do NOT store plaintext passwords — even locally.
  String _hashPassword(String password) {
    const salt = 'cyberlawguardian_salt_v1';
    final bytes = utf8.encode('$salt$password');
    return sha256.convert(bytes).toString();
  }

  /// Restore session from Hive on app launch.
  /// Call this once during app init (before runApp).
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
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (_) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  /// Login: validate against stored records, reject unknown emails or wrong passwords.
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan password tidak boleh kosong';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    if (!email.contains('@')) {
      _errorMessage = 'Format email tidak valid';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    try {
      final usersBox = await Hive.openBox(AppConstants.hiveBoxUsers);
      final userData = usersBox.get(email.toLowerCase());

      if (userData == null) {
        _errorMessage = 'Email tidak terdaftar. Silakan daftar terlebih dahulu.';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      final user = userData as UserModel;
      final inputHash = _hashPassword(password);

      if (user.passwordHash != inputHash) {
        _errorMessage = 'Password salah. Silakan coba lagi.';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      // Login successful — save session
      _currentUser = user;
      _status = AuthStatus.authenticated;

      final sessionBox = await Hive.openBox(AppConstants.hiveBoxSession);
      await sessionBox.put(AppConstants.sessionEmailKey, email.toLowerCase());

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      _status = AuthStatus.unauthenticated;
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
      _errorMessage = 'Semua field harus diisi';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    if (password.length < 8) {
      _errorMessage = 'Password minimal 8 karakter';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    try {
      final usersBox = await Hive.openBox(AppConstants.hiveBoxUsers);
      final normalizedEmail = email.toLowerCase();

      // Check if email already exists
      if (usersBox.containsKey(normalizedEmail)) {
        _errorMessage = 'Email sudah terdaftar. Silakan login.';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      // Compute avatar initials from name
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

      // Persist user record in Hive, keyed by email
      await usersBox.put(normalizedEmail, newUser);

      // Set as current user and save session
      _currentUser = newUser;
      _status = AuthStatus.authenticated;

      final sessionBox = await Hive.openBox(AppConstants.hiveBoxSession);
      await sessionBox.put(AppConstants.sessionEmailKey, normalizedEmail);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  /// Logout: clear session and current user.
  Future<void> logout() async {
    try {
      final sessionBox = await Hive.openBox(AppConstants.hiveBoxSession);
      await sessionBox.delete(AppConstants.sessionEmailKey);
    } catch (_) {}

    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Add score and persist the updated user record.
  Future<void> addScore(int points) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(score: _currentUser!.score + points);
    await _persistCurrentUser();
    notifyListeners();
  }

  /// Mark a challenge as solved, add points, and persist.
  Future<void> markChallengeSolved(String challengeId, int points) async {
    if (_currentUser == null) return;
    if (_currentUser!.solvedChallenges.contains(challengeId)) return;

    final updatedSolved = [..._currentUser!.solvedChallenges, challengeId];
    _currentUser = _currentUser!.copyWith(
      solvedChallenges: updatedSolved,
      score: _currentUser!.score + points,
    );
    await _persistCurrentUser();
    notifyListeners();
  }

  /// Persist the current user's updated record back to Hive.
  Future<void> _persistCurrentUser() async {
    if (_currentUser == null) return;
    try {
      final usersBox = await Hive.openBox(AppConstants.hiveBoxUsers);
      await usersBox.put(_currentUser!.email, _currentUser);
    } catch (_) {}
  }
}
