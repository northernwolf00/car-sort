import 'package:auto_app/blocs/car_event.dart';
import 'package:auto_app/blocs/car_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/car_bloc.dart';
import 'auto_add_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CarBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Listing'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            tooltip: 'Filter by Manufacturer',
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              final manufacturers = bloc.state.cars.map((e) => e.manufacturer).toSet();
              final result = await showDialog<Map<String, String?>>(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Filter by Manufacturer'),
                  children: [
                    ...manufacturers.map(
                      (m) => SimpleDialogOption(
                        child: Text(m),
                        onPressed: () => Navigator.pop(ctx, {'manufacturer': m}),
                      ),
                    ),
                   
                  ],
                ),
              );

              if (result != null) {
                if (result.containsKey('manufacturer')) {
                  bloc.add(FilterCars(manufacturer: result['manufacturer']));
                } else {
                  bloc.add(ClearFilterAndSort());
                }
              }
            },
          ),
          IconButton(
            tooltip: 'Filter by Price Range',
            icon: const Icon(Icons.price_change),
            onPressed: () async {
              final minController = TextEditingController();
              final maxController = TextEditingController();

              final result = await showDialog<Map<String, double?>>(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('Filter by Price Range'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: minController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Min Price',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                        TextField(
                          controller: maxController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Max Price',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(ctx, null),
                      ),
                      ElevatedButton(
                        child: const Text('Apply'),
                        onPressed: () {
                          final min = double.tryParse(minController.text);
                          final max = double.tryParse(maxController.text);
                          if (min != null && max != null && min <= max) {
                            Navigator.pop(ctx, {'min': min, 'max': max});
                          }
                        },
                      ),
                    ],
                  );
                },
              );

              if (result != null && result['min'] != null && result['max'] != null) {
                bloc.add(FilterCarsByPriceRange(
                  minPrice: result['min']!,
                  maxPrice: result['max']!,
                ));
              }
            },
          ),
          IconButton(
            tooltip: 'Sort by Price (Low → High)',
            icon: const Icon(Icons.sort),
            onPressed: () => bloc.add(SortCarsByPrice(true)),
          ),
          IconButton(
            tooltip: 'Reset Filters',
            icon: const Icon(Icons.refresh),
            onPressed: () => bloc.add(ClearFilterAndSort()),
          ),
        ],
      ),
      body: BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          if (state.filteredCars.isEmpty) {
            return const Center(
              child: Text(
                'No cars found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: state.filteredCars.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, index) {
              final car = state.filteredCars[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: const Icon(Icons.directions_car, size: 30, color: Colors.teal),
                  title: Text('${car.name} (${car.model})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${car.manufacturer}  •  \$${car.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AutoAddScreen(editCar: car)),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Car'),
        backgroundColor: Colors.teal,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AutoAddScreen()),
        ),
      ),
    );
  }
}
