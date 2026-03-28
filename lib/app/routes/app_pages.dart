import 'package:get/get.dart';
import '../bindings/app_bindings.dart';
import '../views/auth/login_view.dart';
import '../views/halls/halls_view.dart';
import '../views/bookings/bookings_view.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.halls,
      page: () => const HallsView(),
      binding: HallsBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.bookings,
      page: () => const BookingsView(),
      binding: BookingsBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
