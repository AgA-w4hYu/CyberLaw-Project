import 'package:flutter/foundation.dart';

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

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
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

    if (password.length < 6) {
      _errorMessage = 'Password minimal 6 karakter';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    // Mock success — accept any valid-format credentials
    _currentUser = UserModel(
      id: 'user-001',
      name: email.split('@')[0],
      email: email,
      score: 350,
      rank: 42,
      solvedChallenges: ['crypto-01'],
      avatarInitials: email.substring(0, 2).toUpperCase(),
    );
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

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

    // Mock success
    _currentUser = UserModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      score: 0,
      rank: 99,
      solvedChallenges: const [],
      avatarInitials: name.split(' ').take(2).map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase(),
    );
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void addScore(int points) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(score: _currentUser!.score + points);
      notifyListeners();
    }
  }

  void markChallengeSolved(String challengeId, int points) {
    if (_currentUser != null &&
        !_currentUser!.solvedChallenges.contains(challengeId)) {
      final updatedSolved = [..._currentUser!.solvedChallenges, challengeId];
      _currentUser = _currentUser!.copyWith(
        solvedChallenges: updatedSolved,
        score: _currentUser!.score + points,
      );
      notifyListeners();
    }
  }
}
