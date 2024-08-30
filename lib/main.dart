import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/features/feature1/presentation/weather_screen.dart';
import 'src/features/feature1/domain/weather_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Das ist ein Wrapper Widget, das es erlaubt mehrere "Provider" zu deklarieren.
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                WeatherProvider()), //Hier wird ein "CNP" verwendet, um den "WeatherProvider" zu instanzieren und in den Widget-Baum einzufügen.
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WeatherScreen(),
      ),
    );
  }
}
