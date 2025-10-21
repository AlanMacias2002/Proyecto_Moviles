import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Widgets/home.dart';
import 'package:proyecto_moviles/Widgets/loginScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poke-App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      themeMode: _themeMode,
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
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (ctx) => const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: LoginScreen(),
                    ),
                  );
                },
              ),
            ),
            IconButton(
              icon: Icon(
                _themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: _toggleTheme,
              tooltip: 'Toggle Dark Mode',
            ),
          ],
        ),
        body: const Center(child: HomeWidget()),
      ),
    );
  }
}
