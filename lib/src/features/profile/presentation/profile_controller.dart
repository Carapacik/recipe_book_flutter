import 'package:flutter/foundation.dart';
import 'package:recipe_book_flutter/src/features/profile/data/profile_repository.dart';
import 'package:recipe_book_flutter/src/features/profile/domain/profile.dart';

class ProfileController(final ProfileDataSource _repository)
    extends ChangeNotifier {
  Profile? _profile;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await _repository.getProfile();
    } on Object catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> update({
    required String name,
    required String email,
    required String description,
    String? password,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.update(
        name: name,
        email: email,
        description: description,
        password: password,
      );
      _profile = await _repository.getProfile();
      return true;
    } on Object catch (error) {
      _error = error.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
