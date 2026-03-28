import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;
  final isLoggedIn = false.obs;
  final isSkipped = false.obs;
  final loggedInUsername = ''.obs;

  late Box _authBox;

  @override
  void onInit() {
    super.onInit();
    _authBox = Hive.box('auth');
    _ensureDefaultCredentials();
  }

  void _ensureDefaultCredentials() {
    if (_authBox.get('username') == null) {
      _authBox.put('username', 'admin');
      _authBox.put('password', '123456789');
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() {
    final inputUsername = usernameController.text.trim();
    final inputPassword = passwordController.text;

    final storedUsername = _authBox.get('username');
    final storedPassword = _authBox.get('password');

    if (inputUsername.isEmpty || inputPassword.isEmpty) {
      Get.snackbar(
        'login'.tr,
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    if (inputUsername == storedUsername && inputPassword == storedPassword) {
      isLoggedIn.value = true;
      isSkipped.value = false;
      loggedInUsername.value = inputUsername;
      Get.offAllNamed(AppRoutes.halls);
    } else {
      Get.snackbar(
        'login'.tr,
        'invalid_credentials'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  void skip() {
    isSkipped.value = true;
    isLoggedIn.value = false;
    loggedInUsername.value = '';
    Get.offAllNamed(AppRoutes.halls);
  }

  void logout() {
    isLoggedIn.value = false;
    isSkipped.value = false;
    loggedInUsername.value = '';
    usernameController.clear();
    passwordController.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  /// Returns true if authenticated; redirects to login otherwise
  bool requireAuth() {
    if (!isLoggedIn.value) {
      Get.snackbar(
        'login'.tr,
        'login_required'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
      );
      Get.toNamed(AppRoutes.login);
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
