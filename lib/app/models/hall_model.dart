class HallModel {
  final String id;
  String name;
  final String imageUrl;
  final double rating;
  final double price;
  final String location;
  String date;
  bool isBooked;

  HallModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.location,
    required this.date,
    this.isBooked = false,
  });

  HallModel copyWith({
    String? name,
    String? date,
    bool? isBooked,
  }) {
    return HallModel(
      id: id,
      name: name ?? this.name,
      imageUrl: imageUrl,
      rating: rating,
      price: price,
      location: location,
      date: date ?? this.date,
      isBooked: isBooked ?? this.isBooked,
    );
  }
}
