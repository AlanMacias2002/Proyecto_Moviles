import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Screens/arScreen.dart';
import 'package:proyecto_moviles/main.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class PokemonDataScreen extends StatelessWidget {
    final Map<String, dynamic> pokemon;

  const PokemonDataScreen({super.key, required this.pokemon});

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
    
    final id = pokemon['id'];
    final name = _capitalize(pokemon['name']);
    final types = List<String>.from(pokemon['types'] ?? []);
    final abilities = List<String>.from(pokemon['abilities'] ?? []);
    final description = pokemon['description'] ?? 'No description available.';
    final imageUrl = pokemon['image'] ?? '';
    final stats = List<Map<String, dynamic>>.from(pokemon['stats'] ?? []);
    
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Image.network(
              imageUrl,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 16),
          Text('#$id $name', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: types.map((type) {
              final normalizedType = type.toString().toLowerCase();
              return Image.asset(
                _getTypeIcon(normalizedType),
                width: 120,
                height: 60,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final granted = await _requestCameraPermission(context);
                  if (!granted) return;

                  try {
                    if (cameras.isEmpty) cameras = await availableCameras();
                  } catch (_) {
                    cameras = await availableCameras();
                  }

                  if (cameras.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ARScreen(camera: cameras.first)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No camera available on this device')),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 8),
                    Text('Launch AR Pokémon'),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature not available')),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.volume_up),
                    SizedBox(width: 8),
                    Text('Play Sound'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Description', style: TextStyle(fontSize: 20)),
          Text(description),
          const SizedBox(height: 16),
          const Text('Abilities', style: TextStyle(fontSize: 20)),
          Wrap(
            spacing: 8,
            children: abilities.map((a) => Chip(label: Text(_capitalize(a)))).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Stats', style: TextStyle(fontSize: 20)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: stats.map((statEntry) {
              final statName = statEntry['stat']['name'];
              final baseStat = statEntry['base_stat'];
              return Text('${_capitalize(statName)}: $baseStat');
            }).toList(),
          )
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bug':
        return 'assets/typeIcons/bug.png';
      case 'dark':
        return 'assets/typeIcons/dark.png';
      case 'dragon':
        return 'assets/typeIcons/dragon.png';
      case 'electric':
        return 'assets/typeIcons/electric.png';
      case 'fairy':
        return 'assets/typeIcons/fairy.png';
      case 'fighting':
        return 'assets/typeIcons/fighting.png';
      case 'fire':
        return 'assets/typeIcons/fire.png';
      case 'flying':
        return 'assets/typeIcons/flying.png';
      case 'ghost':
        return 'assets/typeIcons/ghost.png';
      case 'grass':
        return 'assets/typeIcons/grass.png';
      case 'ground':
        return 'assets/typeIcons/ground.png';
      case 'ice':
        return 'assets/typeIcons/ice.png';
      case 'normal':
        return 'assets/typeIcons/normal.png';
      case 'poison':
        return 'assets/typeIcons/poison.png';
      case 'psychic':
        return 'assets/typeIcons/psychic.png';
      case 'rock':
        return 'assets/typeIcons/rock.png';
      case 'steel':
        return 'assets/typeIcons/steel.png';
      case 'water':
        return 'assets/typeIcons/water.png';
      default:
        return 'assets/typeIcons/normal.png';
    }
  }
}