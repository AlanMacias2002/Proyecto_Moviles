import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Services/pokeapi-service.dart'; // importa el servicio de arriba

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemonService = PokeApiService();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: pokemonService.getAllPokemon(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay Pokémon'));
          }

          final allPokemons = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // TextField de búsqueda
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nombre del Pokémon',
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Funcionalidad de búsqueda pendiente',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Grid de 3 columnas
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemCount: allPokemons.length,
                    itemBuilder: (context, index) {
                      final p = allPokemons[index];
                      final imageUrl =
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${p['id']}.png";

                      return InkWell(
                        onTap: () {
                          // Aquí podrías navegar a detalle
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                            Text(
                              p["name"],
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
