import 'package:get/get.dart';
import '../models/hall_model.dart';
import 'auth_controller.dart';

class HallsController extends GetxController {
  final halls = <HallModel>[].obs;

  AuthController get _auth => Get.find<AuthController>();

  int get bookedCount => halls.where((h) => h.isBooked).length;

  @override
  void onInit() {
    super.onInit();
    _loadSampleHalls();
  }

  void _loadSampleHalls() {
    halls.value = [
      HallModel(
        id: '1',
        name: 'New Music Event on Dubai Botek for Valentine Day',
        imageUrl: 'assets/images/hall1.png',
        rating: 4.5,
        price: 500,
        location: 'Riyadh, Marash Tower',
        date: '25.12.2020 ,08:30 AM',
      ),
      HallModel(
        id: '2',
        name: 'Dubai Botek for Valentine Day',
        imageUrl: 'assets/images/hall2.png',
        rating: 3.4,
        price: 500,
        location: 'Riyadh, Marash Tower',
        date: '25.12.2020 ,08:30 AM',
      ),
      HallModel(
        id: '3',
        name: 'Grand Celebration Hall - Spring Gala',
        imageUrl: 'https://images.pexels.com/photos/2747893/pexels-photo-2747893.jpeg?w=400&h=250&fit=crop',
        rating: 4.8,
        price: 750,
        location: 'Dubai, Marina Walk',
        date: '15.01.2021 ,10:00 AM',
      ),
      HallModel(
        id: '4',
        name: 'Business Conference Center',
        imageUrl: 'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=400&h=250&fit=crop',
        rating: 4.2,
        price: 350,
        location: 'Abu Dhabi, Corniche',
        date: '20.02.2021 ,09:00 AM',
      ),
      HallModel(
        id: '5',
        name: 'Royal Wedding & Events Venue',
        imageUrl: 'https://images.unsplash.com/photo-1519225468359-69631e29c30a?w=400&h=250&fit=crop',
        rating: 4.9,
        price: 1200,
        location: 'Sharjah, Al Majaz',
        date: '10.03.2021 ,06:00 PM',
      ),
    ];
  }

  void toggleBooking(String hallId) {
    if (!_auth.requireAuth()) return;

    final index = halls.indexWhere((h) => h.id == hallId);
    if (index != -1) {
      halls[index].isBooked = !halls[index].isBooked;
      halls.refresh();
    }
  }

  void updateHall(String hallId, String newName, String newDate) {
    final index = halls.indexWhere((h) => h.id == hallId);
    if (index != -1) {
      halls[index].name = newName;
      halls[index].date = newDate;
      halls.refresh();
    }
  }

  void removeBooking(String hallId) {
    final index = halls.indexWhere((h) => h.id == hallId);
    if (index != -1) {
      halls[index].isBooked = false;
      halls.refresh();
    }
  }

  List<HallModel> get bookedHalls => halls.where((h) => h.isBooked).toList();
}
