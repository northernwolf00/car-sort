import 'package:auto_app/model/car.dart';

abstract class CarEvent {}
class LoadCars extends CarEvent {}
class AddCar extends CarEvent {
  final Car car;
  AddCar(this.car);
}
class UpdateCar extends CarEvent {
  final Car car;
  UpdateCar(this.car);
}
class FilterCars extends CarEvent {
  final String? manufacturer;
  final String? model;
  FilterCars({this.manufacturer, this.model});
}
class SortCarsByPrice extends CarEvent {
  final bool ascending;
  SortCarsByPrice(this.ascending);
}

class ClearFilterAndSort extends CarEvent {}
class FilterCarsByPriceRange extends CarEvent {
  final double minPrice;
  final double maxPrice;

  FilterCarsByPriceRange({required this.minPrice, required this.maxPrice});
}
