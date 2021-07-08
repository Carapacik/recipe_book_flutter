import 'package:flutter/foundation.dart';
import 'package:recipe_book_flutter/src/features/auth/data/auth_repository.dart';

enum AuthStatus() {
  checking,
  authenticated,
  unauthenticated
}

class AuthController(final AuthDataSource _repository) extends ChangeNotifier {
  AuthStatus _status = AuthStatus.checking;
  bool _isSubmitting = false;
  String? _error;

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  Future<void> restore() async {
    if (!_repository.hasToken) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
    try {
      await _repository.validate();
      _status = AuthStatus.authenticated;
    } on Object catch (error) {
      try {
        await _repository.logout();
      } on Object catch (logoutError) {
        _error = logoutError.toString();
      }
      _error ??= error.toString();
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) =>
      _submit(() => _repository.login(email: email, password: password));

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) => _submit(
    () => _repository.register(name: name, email: email, password: password),
  );

  Future<void> logout() async {
    try {
      await _repository.logout();
      _status = AuthStatus.unauthenticated;
    } on Object catch (error) {
      _error = error.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<bool> _submit(Future<void> Function() action) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      _status = AuthStatus.authenticated;
      return true;
    } on Object catch (error) {
      _error = error.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
