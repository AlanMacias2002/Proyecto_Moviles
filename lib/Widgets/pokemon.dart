import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Screens/pokemonData.dart';
import 'package:proyecto_moviles/Screens/evolutionScreen.dart';
import 'package:proyecto_moviles/Screens/movesScreen.dart';
import 'package:proyecto_moviles/Screens/locationScreen.dart';

class PokemonWidget extends StatefulWidget {
  const PokemonWidget({super.key});

  @override
  State<PokemonWidget> createState() => _PokemonState();
}

class _PokemonState extends State<PokemonWidget> {
  var currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [
    PokemonDataScreen(),
    EvolutionScreen(),
    LocationScreen(),
    MovesScreen(),
  ];

    return Scaffold (
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Evolutions',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Location',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Moves',
          ),
        ],
      ),
    );
  }
}