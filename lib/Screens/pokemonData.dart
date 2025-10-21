import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Screens/arScreen.dart';
import 'package:proyecto_moviles/main.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class PokemonDataScreen extends StatelessWidget {
  const PokemonDataScreen({super.key});

  Future<bool> _requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    // If permission is permanently denied, prompt user to open app settings
    if (status.isPermanentlyDenied) {
      final openSettings = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Camera permission required'),
          content: const Text(
            'Camera access is permanently denied for this app. Please open app settings and enable the Camera permission to use AR features.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Open settings'),
            ),
          ],
        ),
      );

      if (openSettings == true) {
        openAppSettings();
      }
      return false;
    }

    // Show a rationale dialog before requesting permission
    final shouldRequest = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Camera permission'),
        content: const Text(
          'This feature requires access to your camera. Allow camera access?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldRequest != true) return false;

    final result = await Permission.camera.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission permanently denied. You can enable it from app settings.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied.')),
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Image.network(
              'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimages.wikidexcdn.net%2Fmwuploads%2Fwikidex%2Fthumb%2F6%2F6a%2Flatest%2F20141013213057%2FGrovyle.png%2F1200px-Grovyle.png&f=1&nofb=1&ipt=23717423924584b8be0bcabd7d3ac1dfbec5a52d3b6d6d633010e0b002db26d6',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#253', style: TextStyle(fontSize: 24)),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Request permission first
                    final granted = await _requestCameraPermission(context);
                    if (!granted) return;

                    // Ensure the global `cameras` variable is initialized. If accessing it
                    // throws (late initialization), or if it's empty, try to load available cameras.
                    try {
                      if (cameras.isEmpty) {
                        cameras = await availableCameras();
                      }
                    } catch (_) {
                      cameras = await availableCameras();
                    }

                    if (cameras.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ARScreen(camera: cameras.first),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No camera available on this device'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error accessing camera: $e')),
                    );
                  }
                },
                child: const Text('Launch AR Pokémon'),
              ),
            ],
          ),
          const Text('Grovyle', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.network(
                'https://pokeguide.neocities.org/Pic/grassicon.png',
                width: 100,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Description', style: TextStyle(fontSize: 24)),
          const Text('Some texto'),
          const SizedBox(height: 16),
          const Text('Stats', style: TextStyle(fontSize: 24)),
          const Text('Some texto'),
        ],
      ),
    );
  }
}
