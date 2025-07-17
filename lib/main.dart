import 'package:auto_app/blocs/car_event.dart';
import 'package:auto_app/repo/car_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/car_bloc.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => CarRepository(),
      child: BlocProvider(
        create:
            (context) =>
                CarBloc(repository: context.read<CarRepository>())
                  ..add(LoadCars()),
        child: MaterialApp(
          title: 'Auto App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
