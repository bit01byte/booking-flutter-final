import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/bookings_controller.dart';
import '../../controllers/halls_controller.dart';
import '../settings/settings_popup.dart';
import 'widgets/booking_item.dart';

class BookingsView extends GetView<BookingsController> {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final hallsCtrl = Get.find<HallsController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: Text(
          'bookings'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Cart count badge
          Obx(() => Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hallsCtrl.bookedCount
                              .toString()
                              .padLeft(2, '0'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'your_cart'.tr,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 9),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: SettingsPopup.show,
          ),
        ],
      ),
      body: Obx(() {
        final booked = controller.bookedHalls;

        if (booked.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_bookings'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // ── Count badge ──
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.format_list_bulleted,
                      color: Colors.blue.shade700, size: 18),
                  const SizedBox(width: 8),
                  Obx(() => Text(
                        '${controller.bookedHalls.length} ${'items_added'.tr}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ],
              ),
            ),

            // ── Bookings list ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: booked.length,
                itemBuilder: (context, index) {
                  return BookingItem(hall: booked[index]);
                },
              ),
            ),

            // ── Bottom section: Coupon + Total ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Coupon row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.couponController,
                          decoration: InputDecoration(
                            hintText: 'set_code'.tr,
                            hintStyle:
                                TextStyle(color: Colors.grey.shade400),
                            prefixIcon: Icon(Icons.local_offer_outlined,
                                color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: controller.checkCoupon,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'check'.tr,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Total price row
                  Obx(() => Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total_order'.tr,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (controller.hasDiscount)
                                Text(
                                  '${controller.totalPrice.toInt()} SR',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                              Text(
                                '${controller.discountedPrice.toStringAsFixed(0)} SR',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: controller.hasDiscount
                                      ? Colors.green.shade700
                                      : theme.colorScheme.primary,
                                ),
                              ),
                              if (controller.hasDiscount)
                                Text(
                                  '${controller.discountPercent.value.toInt()}% discount applied ✓',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
