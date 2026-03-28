import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/halls_controller.dart';
import '../controllers/bookings_controller.dart';
import '../controllers/settings_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(SettingsController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class HallsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HallsController>(() => HallsController());
  }
}

class BookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingsController>(() => BookingsController());
  }
}
