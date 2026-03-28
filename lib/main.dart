import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/bindings/app_bindings.dart';
import 'app/controllers/settings_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('auth');
  await Hive.openBox('settings');

  // Pre-store default admin credentials if not present
  final authBox = Hive.box('auth');
  if (authBox.get('username') == null) {
    await authBox.put('username', 'admin');
    await authBox.put('password', '123456789');
  }

  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Put SettingsController permanently so it persists across routes
    final settingsCtrl = Get.put(SettingsController(), permanent: true);

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Booking App',
          initialBinding: InitialBinding(),
          initialRoute: AppRoutes.login,
          getPages: AppPages.routes,
          translations: AppTranslations(),
          locale: settingsCtrl.currentLocale,
          fallbackLocale: const Locale('en', 'US'),

          // Light theme
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1565C0),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Dark theme
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1565C0),
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1A1A2E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          themeMode: settingsCtrl.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
        ));
  }
}
