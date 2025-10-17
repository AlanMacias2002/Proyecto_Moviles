import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Screens/abilitiesScreen.dart';
import 'package:proyecto_moviles/Screens/movesScreen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMenuButton(
            context,
            title: 'Pokédex',
            color: Colors.redAccent,
            icon: Icons.catching_pokemon,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AbilitiesScreen(),
                ),
              );
            },
          ),
          _buildMenuButton(
            context,
            title: 'Moves',
            color: Colors.blueAccent,
            icon: Icons.flash_on,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovesScreen()),
              );
            },
          ),
          _buildMenuButton(
            context,
            title: 'Abilities',
            color: Colors.green,
            icon: Icons.auto_awesome,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AbilitiesScreen()),
              );
            },
          ),
          _buildMenuButton(
            context,
            title: 'Parties',
            color: Colors.purple,
            icon: Icons.group,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(16),
        elevation: 4,
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
