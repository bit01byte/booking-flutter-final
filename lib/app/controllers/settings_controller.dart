import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingsController extends GetxController {
  final isDarkMode = false.obs;
  final currentLanguage = 'en'.obs;

  late Box _settingsBox;

  Locale get currentLocale {
    return currentLanguage.value == 'ar'
        ? const Locale('ar', 'AR')
        : const Locale('en', 'US');
  }

  @override
  void onInit() {
    super.onInit();
    _settingsBox = Hive.box('settings');
    _loadSettings();
  }

  void _loadSettings() {
    isDarkMode.value = _settingsBox.get('isDarkMode', defaultValue: false);
    currentLanguage.value = _settingsBox.get('language', defaultValue: 'en');
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _settingsBox.put('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void changeLanguage(String lang) {
    currentLanguage.value = lang;
    _settingsBox.put('language', lang);
    final locale = lang == 'ar'
        ? const Locale('ar', 'AR')
        : const Locale('en', 'US');
    Get.updateLocale(locale);
  }
}
