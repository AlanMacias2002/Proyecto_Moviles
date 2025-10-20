import 'package:flutter/material.dart';
import 'package:proyecto_moviles/TestData/Data.dart';
import 'package:proyecto_moviles/Widgets/pokemonIcon.dart';

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
									contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
												const SnackBar(content: Text('Funcionalidad de busqueda')),
											);
										},
									),
								),
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
										return PokemonIcon(id: p.id);
									},
								),
							),
						],
					),
				),
		);
	}
}

