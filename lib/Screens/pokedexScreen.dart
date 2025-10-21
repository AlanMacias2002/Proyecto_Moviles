import 'package:flutter/material.dart';
import 'package:proyecto_moviles/TestData/Data.dart';
import 'package:proyecto_moviles/Widgets/pokemonIcon.dart';
import 'package:proyecto_moviles/Widgets/pokemon.dart';

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Nombre del pokemon',
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
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad de busqueda'),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Barras de filtro (no funcionales por ahora): Tipo y Generación
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'Todos',
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Tipo',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                      DropdownMenuItem(value: 'Planta', child: Text('Planta')),
                      DropdownMenuItem(value: 'Fuego', child: Text('Fuego')),
                      DropdownMenuItem(value: 'Agua', child: Text('Agua')),
                      DropdownMenuItem(value: 'Eléctrico', child: Text('Eléctrico')),
                      DropdownMenuItem(value: 'Hielo', child: Text('Hielo')),
                      DropdownMenuItem(value: 'Tierra', child: Text('Tierra')),
                      DropdownMenuItem(value: 'Roca', child: Text('Roca')),
                      DropdownMenuItem(value: 'Lucha', child: Text('Lucha')),
                      DropdownMenuItem(value: 'Veneno', child: Text('Veneno')),
                      DropdownMenuItem(value: 'Volador', child: Text('Volador')),
                      DropdownMenuItem(value: 'Psíquico', child: Text('Psíquico')),
                      DropdownMenuItem(value: 'Bicho', child: Text('Bicho')),
                      DropdownMenuItem(value: 'Fantasma', child: Text('Fantasma')),
                      DropdownMenuItem(value: 'Dragón', child: Text('Dragón')),
                      DropdownMenuItem(value: 'Siniestro', child: Text('Siniestro')),
                      DropdownMenuItem(value: 'Acero', child: Text('Acero')),
                      DropdownMenuItem(value: 'Hada', child: Text('Hada')),
                    ],
                    onChanged: (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filtro de tipo (pendiente)')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'Todas',
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Generación',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Todas', child: Text('Todas')),
                      DropdownMenuItem(value: 'Gen 1', child: Text('Gen 1')),
                      DropdownMenuItem(value: 'Gen 2', child: Text('Gen 2')),
                      DropdownMenuItem(value: 'Gen 3', child: Text('Gen 3')),
                      DropdownMenuItem(value: 'Gen 4', child: Text('Gen 4')),
                      DropdownMenuItem(value: 'Gen 5', child: Text('Gen 5')),
                      DropdownMenuItem(value: 'Gen 6', child: Text('Gen 6')),
                      DropdownMenuItem(value: 'Gen 7', child: Text('Gen 7')),
                      DropdownMenuItem(value: 'Gen 8', child: Text('Gen 8')),
                      DropdownMenuItem(value: 'Gen 9', child: Text('Gen 9')),
                    ],
                    onChanged: (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filtro de generación (pendiente)')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Grid de 3 columnas
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 por fila para cubrir el ancho
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1, // cuadrados
                ),
                itemCount: samplePokemons.length,
                itemBuilder: (context, index) {
                  final p = samplePokemons[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PokemonWidget(),
                        ),
                      );
                    },
                    child: PokemonIcon(id: p.id),
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
