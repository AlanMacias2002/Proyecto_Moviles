import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Widgets/home.dart';
import 'package:proyecto_moviles/Screens/settingsScreen.dart';
import 'package:camera/camera.dart';

import 'package:proyecto_moviles/Widgets/auth_gate.dart';
import 'package:proyecto_moviles/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


late List<CameraDescription> cameras;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras(); // Load available cameras
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthGate()));
                },
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                        themeMode: _themeMode,
                        onThemeChanged: _setThemeMode,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: const Center(child: HomeWidget()),
      ),
    );
  }
}