import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/features/profile/data/profile_repository.dart';
import 'package:recipe_book_flutter/src/features/profile/domain/profile.dart';
import 'package:recipe_book_flutter/src/features/profile/presentation/profile_controller.dart';

void main() {
  group('ProfileController', () {
    test('loads profile and exposes state transitions', () async {
      final repository = _ProfileDataSource();
      final controller = ProfileController(repository);
      final loadingStates = <bool>[];
      controller.addListener(() => loadingStates.add(controller.isLoading));

      await controller.load();

      expect(controller.profile?.name, 'Chef');
      expect(controller.error, isNull);
      expect(loadingStates, [true, false]);
    });

    test('reports profile loading failure', () async {
      final repository = _ProfileDataSource()..loadError = true;
      final controller = ProfileController(repository);

      await controller.load();

      expect(controller.profile, isNull);
      expect(controller.error, contains('load failed'));
      expect(controller.isLoading, isFalse);
    });

    test('updates fields and reloads profile', () async {
      final repository = _ProfileDataSource();
      final controller = ProfileController(repository);

      final bool result = await controller.update(
        name: 'New Chef',
        email: 'new@example.com',
        description: 'Updated',
        password: 'secret',
      );

      expect(result, isTrue);
      expect(repository.updatedName, 'New Chef');
      expect(repository.updatedPassword, 'secret');
      expect(repository.loadCalls, 1);
      expect(controller.isSaving, isFalse);
    });

    test('reports update failure without reloading', () async {
      final repository = _ProfileDataSource()..updateError = true;
      final controller = ProfileController(repository);

      final bool result = await controller.update(
        name: 'Chef',
        email: 'chef@example.com',
        description: '',
      );

      expect(result, isFalse);
      expect(repository.loadCalls, 0);
      expect(controller.error, contains('update failed'));
      expect(controller.isSaving, isFalse);
    });

    test('reports reload failure after a successful update', () async {
      final repository = _ProfileDataSource()..loadError = true;
      final controller = ProfileController(repository);

      final bool result = await controller.update(
        name: 'Chef',
        email: 'chef@example.com',
        description: '',
      );

      expect(result, isFalse);
      expect(repository.loadCalls, 1);
      expect(controller.error, contains('load failed'));
      expect(controller.isSaving, isFalse);
    });
  });
}

class _ProfileDataSource() implements ProfileDataSource {
  bool loadError = false;
  bool updateError = false;
  int loadCalls = 0;
  String? updatedName;
  String? updatedPassword;

  @override
  Future<Profile> getProfile() async {
    loadCalls++;
    if (loadError) {
      throw StateError('load failed');
    }
    return const Profile(
      name: 'Chef',
      email: 'chef@example.com',
      description: 'Bio',
      recipesCount: 1,
      likesCount: 2,
      favoritesCount: 3,
    );
  }

  @override
  Future<void> update({
    required String name,
    required String email,
    required String description,
    String? password,
  }) async {
    updatedName = name;
    updatedPassword = password;
    if (updateError) {
      throw StateError('update failed');
    }
  }
}
