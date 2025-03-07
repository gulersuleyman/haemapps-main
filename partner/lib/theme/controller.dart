import 'dart:ui';
import 'package:get_storage/get_storage.dart';

class ThemeController {
  final box = GetStorage();

  Future<void> updateTheme({bool? value}) async {
    final bool isDark = isDarkModeEnabled();
    await box.write('isDark', value ?? !isDark);
  }

  bool isDarkModeEnabled() {
    return box.read('isDark') ?? getSystemDefault();
  }

  bool getSystemDefault() {
    final systemDefault = PlatformDispatcher.instance.platformBrightness;
    return systemDefault == Brightness.dark;
  }
}
