import 'package:recipe_book_flutter/src/core/network/api_client.dart';
import 'package:recipe_book_flutter/src/core/storage/token_storage.dart';
import 'package:recipe_book_flutter/src/features/profile/domain/profile.dart';

abstract interface class ProfileDataSource() {
  Future<Profile> getProfile();

  Future<void> update({
    required String name,
    required String email,
    required String description,
    String? password,
  });
}

class const ProfileRepository(
  final ApiGateway _apiClient,
  final TokenStorage _tokenStorage,
) implements ProfileDataSource {
  @override
  Future<Profile> getProfile() async {
    final Map<String, dynamic> data = await _apiClient
        .get<Map<String, dynamic>>('profile');
    return Profile.fromJson(data);
  }

  @override
  Future<void> update({
    required String name,
    required String email,
    required String description,
    String? password,
  }) async {
    await _apiClient.putVoid(
      'profile',
      data: {
        'name': name,
        'email': email,
        'description': description,
        if (password != null && password.isNotEmpty) 'password': password,
      },
    );
    await _tokenStorage.saveEmail(email);
  }
}
