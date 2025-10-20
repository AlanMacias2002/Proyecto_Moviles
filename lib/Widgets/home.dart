import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Screens/abilitiesScreen.dart';
import 'package:proyecto_moviles/Screens/movesScreen.dart';
import 'package:proyecto_moviles/Screens/partiesScreen.dart';
import 'package:proyecto_moviles/Screens/pokedex.dart';
import 'package:proyecto_moviles/Widgets/loginScreen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
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
                  builder: (context) => PokedexScreen(),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PartiesScreen()),
              );
            },
          ),
        ],
          ),
        ),
        // Botón redondo pequeño, gris, en la esquina inferior izquierda
        Positioned(
          left: 16,
          bottom: 16,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Material(
              color: Colors.grey[700],
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
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
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
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
