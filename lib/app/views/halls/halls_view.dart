import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/halls_controller.dart';
import '../../controllers/auth_controller.dart';
import '../settings/settings_popup.dart';
import 'widgets/hall_card.dart';
import '../../routes/app_routes.dart';

class HallsView extends GetView<HallsController> {
  const HallsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context, authCtrl, theme),
      body: Obx(() => controller.halls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: controller.halls.length,
              itemBuilder: (context, index) {
                final hall = controller.halls[index];
                return HallCard(
                  hall: hall,
                  onBook: () => controller.toggleBooking(hall.id),
                );
              },
            )),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, AuthController authCtrl, ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      title: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${('welcome_back').tr} ${authCtrl.isLoggedIn.value ? authCtrl.loggedInUsername.value : ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'occasion_question'.tr,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )),
      actions: [
        // Cart / Bookings count badge
        Obx(() => GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.bookings),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white38),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.bookedCount.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'your_cart'.tr,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),

        // Settings button
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: SettingsPopup.show,
        ),
      ],
    );
  }
}
