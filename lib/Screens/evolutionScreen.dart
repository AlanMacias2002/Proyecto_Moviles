import 'package:flutter/material.dart';

class EvolutionScreen extends StatelessWidget {
  const EvolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Evolutions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            EvolutionRow(
              from: 'Bulbasaur',
              to: 'Ivysaur',
              level: 16,
              fromImageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
              toImageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
            ),
            EvolutionRow(
              from: 'Ivysaur',
              to: 'Venusaur',
              level: 32,
              fromImageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
              toImageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
            ),
          ],
        ),
      ),
    );
  }
}

class EvolutionRow extends StatelessWidget {
  final String from;
  final String to;
  final int level;
  final String fromImageUrl;
  final String toImageUrl;

  const EvolutionRow({
    super.key,
    required this.from,
    required this.to,
    required this.level,
    required this.fromImageUrl,
    required this.toImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Image.network(fromImageUrl, width: 80),
              Text(from),
            ],
          ),
          Column(
            children: [
              Text('Level $level'),
              const Icon(Icons.arrow_forward),
            ],
          ),
          Column(
            children: [
              Image.network(toImageUrl, width: 80),
              Text(to),
            ],
          ),
        ],
      ),
    );
  }
}

