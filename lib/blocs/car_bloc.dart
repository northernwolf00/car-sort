import 'package:auto_app/blocs/car_event.dart';
import 'package:auto_app/blocs/car_state.dart';
import 'package:auto_app/repo/car_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final CarRepository repository;

  CarBloc({required this.repository}) : super(CarState(cars: [], filteredCars: [])) {
    on<LoadCars>((event, emit) async {
      final cars = await repository.fetchCars();
      emit(CarState(cars: cars, filteredCars: cars));
    });

    on<AddCar>((event, emit) {
      repository.addCar(event.car);
      add(LoadCars());
    });

    on<UpdateCar>((event, emit) {
      repository.updateCar(event.car);
      add(LoadCars());
    });

    on<FilterCars>((event, emit) {
      final filtered = state.cars.where((car) {
        final matchesManufacturer = event.manufacturer == null || car.manufacturer == event.manufacturer;
        final matchesModel = event.model == null || car.model == event.model;
        return matchesManufacturer && matchesModel;
      }).toList();
      emit(state.copyWith(filteredCars: filtered, selectedManufacturer: event.manufacturer, selectedModel: event.model));
    });

    on<FilterCarsByPriceRange>((event, emit) {
      final filtered = state.cars.where((car) =>
          car.price >= event.minPrice && car.price <= event.maxPrice).toList();
      emit(state.copyWith(filteredCars: filtered));
    });

    on<SortCarsByPrice>((event, emit) {
      final sorted = [...state.filteredCars];
      sorted.sort((a, b) =>
          event.ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
      emit(state.copyWith(filteredCars: sorted));
    });

    on<ClearFilterAndSort>((event, emit) {
      emit(state.copyWith(
        filteredCars: [...state.cars],
        selectedManufacturer: null,
        selectedModel: null,
      ));
    });
  }
}
