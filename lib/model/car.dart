class Car {
  final int id;
  final String name;
  final String manufacturer;
  final String model;
  final int year;
  final double price;

  Car({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.model,
    required this.year,
    required this.price,
  });

  Car copyWith({
    int? id,
    String? name,
    String? manufacturer,
    String? model,
    int? year,
    double? price,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      year: year ?? this.year,
      price: price ?? this.price,
    );
  }
}