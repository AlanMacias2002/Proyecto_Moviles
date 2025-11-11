import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Screens/pokemonData.dart';
import 'package:proyecto_moviles/Screens/evolutionScreen.dart';
import 'package:proyecto_moviles/Screens/movesScreen.dart';
import 'package:proyecto_moviles/Screens/locationScreen.dart';

class PokemonWidget extends StatefulWidget {
  final Map<String, dynamic> pokemon;

  const PokemonWidget({super.key, required this.pokemon});

  @override
  State<PokemonWidget> createState() => _PokemonState();
}


class _PokemonState extends State<PokemonWidget> {
  var currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      PokemonDataScreen(pokemon: widget.pokemon),
      EvolutionScreen(pokemon: widget.pokemon),
      LocationScreen(pokemon: widget.pokemon),
      MovesScreen(pokemon: widget.pokemon),
    ];

    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.info), label: 'Info'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Evolutions'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Location'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Moves'),
        ],
      ),
    );
  }
}
