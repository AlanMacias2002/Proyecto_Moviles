import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Widgets/home.dart';
import 'package:proyecto_moviles/Widgets/loginScreen.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poke-App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Poké-App'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (ctx) => const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Center(child: HomeWidget()),
      ),
    );
  }
}
