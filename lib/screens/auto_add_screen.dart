import 'package:auto_app/blocs/car_event.dart';
import 'package:auto_app/model/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/car_bloc.dart';

class AutoAddScreen extends StatefulWidget {
  final Car? editCar;
  const AutoAddScreen({super.key, this.editCar});

  @override
  State<AutoAddScreen> createState() => _AutoAddScreenState();
}

class _AutoAddScreenState extends State<AutoAddScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, manufacturer, model;
  late int year;
  late double price;

  final List<String> manufacturers = [
    'Ford',
    'Toyota',
    'Honda',
    'BMW',
    'Mercedes',
    'Hyundai',
  ];

  final Map<String, List<String>> modelsByManufacturer = {
    'Ford': ['Focus', 'Mustang', 'Escape'],
    'Toyota': ['Corolla', 'Camry', 'RAV4'],
    'Honda': ['Civic', 'Accord', 'CR-V'],
    'BMW': ['X3', 'X5', 'M3'],
    'Mercedes': ['C-Class', 'E-Class', 'GLA'],
    'Hyundai': ['Elantra', 'Sonata', 'Tucson'],
  };

  @override
  void initState() {
    super.initState();
    if (widget.editCar != null) {
      final car = widget.editCar!;
      name = car.name;
      manufacturer = car.manufacturer;
      model = car.model;
      year = car.year;
      price = car.price;
    } else {
      manufacturer = manufacturers.first;
      model = modelsByManufacturer[manufacturer]!.first;
      name = '';
      year = 2020;
      price = 10000.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CarBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editCar != null ? 'Edit Car' : 'Add Car'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: 'Car Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.drive_eta),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                onChanged: (v) => name = v,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: manufacturer,
                decoration: const InputDecoration(
                  labelText: 'Manufacturer',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.factory),
                ),
                items: manufacturers
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    manufacturer = value!;
                    model = modelsByManufacturer[manufacturer]!.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: model,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.model_training),
                ),
                items: modelsByManufacturer[manufacturer]!
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (value) => setState(() => model = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: year.toString(),
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final y = int.tryParse(v ?? '');
                  return (y == null || y < 1900 || y > DateTime.now().year + 1)
                      ? 'Enter a valid year'
                      : null;
                },
                onChanged: (v) => year = int.tryParse(v) ?? year,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: price.toString(),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final p = double.tryParse(v ?? '');
                  return (p == null || p < 0) ? 'Enter a valid price' : null;
                },
                onChanged: (v) => price = double.tryParse(v) ?? price,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(widget.editCar != null ? Icons.save : Icons.add),
                label: Text(
                  widget.editCar != null ? 'Update Car' : 'Add Car',
                  style: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newCar = Car(
                      id: widget.editCar?.id ?? DateTime.now().millisecondsSinceEpoch,
                      name: name,
                      manufacturer: manufacturer,
                      model: model,
                      year: year,
                      price: price,
                    );
                    if (widget.editCar != null) {
                      bloc.add(UpdateCar(newCar));
                    } else {
                      bloc.add(AddCar(newCar));
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
