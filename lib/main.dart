import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Widgets/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poke-App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Poké-App')),
        body: Center(child: HomeWidget()),
      ),
    );
  }
}
