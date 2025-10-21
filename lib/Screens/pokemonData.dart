import 'package:flutter/material.dart';

class PokemonDataScreen extends StatelessWidget {
  const PokemonDataScreen({super.key});

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
          const Text('#253', style: TextStyle(fontSize: 24)),
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
