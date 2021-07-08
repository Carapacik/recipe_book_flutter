import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/features/auth/data/auth_repository.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_controller.dart';

void main() {
  group('AuthController', () {
    test('restores unauthenticated state without a token', () async {
      final repository = _AuthDataSource();
      final controller = AuthController(repository);

      await controller.restore();

      expect(controller.status, AuthStatus.unauthenticated);
      expect(repository.validateCalls, 0);
    });

    test('validates a stored token', () async {
      final repository = _AuthDataSource()..hasTokenValue = true;
      final controller = AuthController(repository);

      await controller.restore();

      expect(controller.status, AuthStatus.authenticated);
      expect(repository.validateCalls, 1);
    });

    test('clears an invalid token and exposes validation failure', () async {
      final repository = _AuthDataSource()
        ..hasTokenValue = true
        ..validateError = true;
      final controller = AuthController(repository);

      await controller.restore();

      expect(controller.status, AuthStatus.unauthenticated);
      expect(repository.logoutCalls, 1);
      expect(controller.error, contains('invalid token'));
    });

    test('login and registration update submission state', () async {
      final repository = _AuthDataSource();
      final controller = AuthController(repository);
      final states = <bool>[];
      controller.addListener(() => states.add(controller.isSubmitting));

      final bool loginResult = await controller.login(
        email: 'chef@example.com',
        password: 'secret',
      );
      final bool registerResult = await controller.register(
        name: 'Chef',
        email: 'new@example.com',
        password: 'secret',
      );

      expect(loginResult, isTrue);
      expect(registerResult, isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(states, containsAllInOrder([true, false, true, false]));
      expect(repository.loginEmail, 'chef@example.com');
      expect(repository.registerName, 'Chef');
    });

    test('keeps unauthenticated state and error after login failure', () async {
      final repository = _AuthDataSource()..submitError = true;
      final controller = AuthController(repository);

      final bool result = await controller.login(email: 'bad', password: 'bad');

      expect(result, isFalse);
      expect(controller.isSubmitting, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.error, contains('submit failed'));
    });

    test('logout updates state and reports failures', () async {
      final repository = _AuthDataSource();
      final controller = AuthController(repository);
      await controller.login(email: 'a', password: 'b');
      await controller.logout();
      expect(controller.status, AuthStatus.unauthenticated);

      repository.logoutError = true;
      await controller.logout();
      expect(controller.error, contains('logout failed'));
    });
  });
}

class _AuthDataSource() implements AuthDataSource {
  bool hasTokenValue = false;
  bool validateError = false;
  bool submitError = false;
  bool logoutError = false;
  int validateCalls = 0;
  int logoutCalls = 0;
  String? loginEmail;
  String? registerName;

  @override
  bool get hasToken => hasTokenValue;

  @override
  Future<void> login({required String email, required String password}) async {
    loginEmail = email;
    if (submitError) {
      throw StateError('submit failed');
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    registerName = name;
    if (submitError) {
      throw StateError('submit failed');
    }
  }

  @override
  Future<void> validate() async {
    validateCalls++;
    if (validateError) {
      throw StateError('invalid token');
    }
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
    if (logoutError) {
      throw StateError('logout failed');
    }
  }
}
