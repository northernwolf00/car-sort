import 'package:auto_app/model/car.dart';

class CarState {
  final List<Car> cars;
  final List<Car> filteredCars;
  final String? selectedManufacturer;
  final String? selectedModel;

  CarState({
    required this.cars,
    required this.filteredCars,
    this.selectedManufacturer,
    this.selectedModel,
  });

  CarState copyWith({
    List<Car>? cars,
    List<Car>? filteredCars,
    String? selectedManufacturer,
    String? selectedModel,
  }) {
    return CarState(
      cars: cars ?? this.cars,
      filteredCars: filteredCars ?? this.filteredCars,
      selectedManufacturer: selectedManufacturer ?? this.selectedManufacturer,
      selectedModel: selectedModel ?? this.selectedModel,
    );
  }
}
