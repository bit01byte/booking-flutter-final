import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/auth_controller.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

  static void show() {
    Get.dialog(
      const Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: SettingsPopup(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsCtrl = Get.find<SettingsController>();
    final authCtrl = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.settings, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'settings'.tr,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),

          const Divider(height: 24),

          // ─── Language Section ───
          Text(
            'language'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),

          Obx(() => Row(
                children: [
                  Expanded(
                    child: _LanguageButton(
                      label: 'english'.tr,
                      isSelected: settingsCtrl.currentLanguage.value == 'en',
                      onTap: () => settingsCtrl.changeLanguage('en'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LanguageButton(
                      label: 'arabic'.tr,
                      isSelected: settingsCtrl.currentLanguage.value == 'ar',
                      onTap: () => settingsCtrl.changeLanguage('ar'),
                    ),
                  ),
                ],
              )),

          const SizedBox(height: 20),

          // ─── Theme Section ───
          Text(
            'theme'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),

          Obx(() => Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          settingsCtrl.isDarkMode.value
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: settingsCtrl.isDarkMode.value
                              ? Colors.indigo
                              : Colors.amber,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          settingsCtrl.isDarkMode.value
                              ? 'dark_mode'.tr
                              : 'light_mode'.tr,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: settingsCtrl.isDarkMode.value,
                      onChanged: (_) => settingsCtrl.toggleTheme(),
                      activeColor: Colors.blue.shade700,
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 20),

          // ─── Logout / Login Status ───
          Obx(() => authCtrl.isLoggedIn.value
              ? SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      authCtrl.logout();
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade700 : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
