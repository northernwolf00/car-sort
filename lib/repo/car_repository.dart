

import 'package:auto_app/model/car.dart';

class CarRepository {
  final List<Car> _cars = [
    Car(id: 1, name: 'Focus', manufacturer: 'Ford', model: 'Focus', year: 2019, price: 13000),
    Car(id: 2, name: 'Mustang', manufacturer: 'Ford', model: 'Mustang', year: 2020, price: 35000),
    Car(id: 3, name: 'Corolla', manufacturer: 'Toyota', model: 'Corolla', year: 2021, price: 15000),
    Car(id: 4, name: 'Camry', manufacturer: 'Toyota', model: 'Camry', year: 2022, price: 18000),
    Car(id: 5, name: 'Civic', manufacturer: 'Honda', model: 'Civic', year: 2020, price: 14000),
    Car(id: 6, name: 'Accord', manufacturer: 'Honda', model: 'Accord', year: 2022, price: 19000),
  ];

  Future<List<Car>> fetchCars() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [..._cars];
  }

  void addCar(Car car) {
    _cars.add(car);
  }

  void updateCar(Car updatedCar) {
    final index = _cars.indexWhere((car) => car.id == updatedCar.id);
    if (index != -1) _cars[index] = updatedCar;
  }
}