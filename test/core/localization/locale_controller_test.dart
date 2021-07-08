import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/localization/locale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('uses Russian by default and persists locale toggles', () async {
    SharedPreferences.setMockInitialValues({});
    final LocaleController controller = await LocaleController.create();
    expect(controller.locale, LocaleController.russian);

    await controller.toggle();
    expect(controller.locale, LocaleController.english);
    expect(
      (await SharedPreferences.getInstance()).getString('app_locale'),
      'en',
    );

    await controller.toggle();
    expect(controller.locale, LocaleController.russian);
  });

  test('restores only supported persisted language', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'en'});
    expect((await LocaleController.create()).locale, LocaleController.english);

    SharedPreferences.setMockInitialValues({'app_locale': 'de'});
    expect((await LocaleController.create()).locale, LocaleController.russian);
  });
}
