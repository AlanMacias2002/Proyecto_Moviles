import 'package:flutter/material.dart';

class AbilityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> ability;

  const AbilityDetailScreen({super.key, required this.ability});

  @override
  Widget build(BuildContext context) {
    // Aquí la "pokemon" viene ya como List<dynamic> desde el servicio
    final List<dynamic> pokemonList =
        (ability['pokemon'] as List<dynamic>?) ?? [];

    final String name = (ability['name'] ?? '').toString();
    final String shortEffect =
        (ability['short_effect'] ?? 'No description available').toString();

    return Scaffold(
      appBar: AppBar(title: Text(name.toUpperCase())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              shortEffect,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20),
            Text(
              'Pokémon with this ability:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: pokemonList.isEmpty
                  ? const Center(
                      child: Text(
                        'No Pokémon found for this ability.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: pokemonList.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 12, color: Colors.grey),
                      itemBuilder: (context, index) {
                        final entry =
                            pokemonList[index] as Map<String, dynamic>;
                        final poke =
                            entry['pokemon'] as Map<String, dynamic>? ?? {};
                        final pokeName = (poke['name'] ?? 'unknown').toString();

                        // extraer id desde la URL si existe
                        String? spriteUrl;
                        final url = poke['url']?.toString();
                        if (url != null && url.isNotEmpty) {
                          final segments = url
                              .split('/')
                              .where((s) => s.isNotEmpty)
                              .toList();
                          final idStr = segments.isNotEmpty
                              ? segments.last
                              : null;
                          if (idStr != null) {
                            spriteUrl =
                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$idStr.png';
                          }
                        }

                        return ListTile(
                          leading: spriteUrl != null
                              ? Image.network(
                                  spriteUrl,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                )
                              : const Icon(Icons.catching_pokemon),
                          title: Text(
                            pokeName.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
