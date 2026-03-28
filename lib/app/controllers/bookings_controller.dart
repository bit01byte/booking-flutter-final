import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/hall_model.dart';
import 'halls_controller.dart';

class BookingsController extends GetxController {
  final couponController = TextEditingController();
  final discountPercent = 0.0.obs;
  final appliedCode = ''.obs;

  HallsController get _halls => Get.find<HallsController>();

  List<HallModel> get bookedHalls => _halls.bookedHalls;

  double get totalPrice =>
      bookedHalls.fold(0.0, (sum, h) => sum + h.price);

  double get discountedPrice =>
      totalPrice * (1 - discountPercent.value / 100);

  bool get hasDiscount => discountPercent.value > 0;

  void checkCoupon() {
    final code = couponController.text.trim().toUpperCase();

    switch (code) {
      case 'A123':
        discountPercent.value = 10;
        appliedCode.value = code;
        _showSuccess('10%');
        break;
      case 'B123':
        discountPercent.value = 20;
        appliedCode.value = code;
        _showSuccess('20%');
        break;
      case 'C123':
        discountPercent.value = 30;
        appliedCode.value = code;
        _showSuccess('30%');
        break;
      default:
        discountPercent.value = 0;
        appliedCode.value = '';
        Get.snackbar(
          'Error',
          'invalid_coupon'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(12),
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
    }
  }

  void _showSuccess(String percent) {
    Get.snackbar(
      'coupon_applied'.tr,
      '$percent discount applied successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  void removeBooking(String hallId) {
    _halls.removeBooking(hallId);
    // Reset discount if no bookings left
    if (bookedHalls.isEmpty) {
      discountPercent.value = 0;
      appliedCode.value = '';
      couponController.clear();
    }
    update();
  }

  void showEditDialog(HallModel hall) {
    final nameCtrl = TextEditingController(text: hall.name);
    final dateCtrl = TextEditingController(text: hall.date);

    Get.dialog(
      AlertDialog(
        title: Text('edit_booking'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'hall_name'.tr,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateCtrl,
              decoration: InputDecoration(
                labelText: 'event_date'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              _halls.updateHall(hall.id, nameCtrl.text.trim(), dateCtrl.text.trim());
              update();
              Get.back();
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}
