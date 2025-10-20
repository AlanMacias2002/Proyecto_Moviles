import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Models/pokemons.dart';
import 'package:proyecto_moviles/TestData/Data.dart';


class PokemonIcon extends StatelessWidget {
	const PokemonIcon({super.key, required this.id});

	final int id;

	@override
	Widget build(BuildContext context) {
		Pokemon? pokemon;
		try {
			pokemon = samplePokemons.firstWhere((p) => p.id == id);
		} catch (_) {
			pokemon = null;
		}

		if (pokemon == null) {
			return _NotFoundCard(id: id);
		}

		return AspectRatio(
			aspectRatio: 1,
			child: Container(
				decoration: BoxDecoration(
					color: Colors.white,
					borderRadius: BorderRadius.circular(12),
					boxShadow: const [
						BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
					],
				),
				padding: const EdgeInsets.all(8),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Expanded(
							child: ClipRRect(
								borderRadius: BorderRadius.circular(8),
								child: Image.network(
									pokemon.imageUrl,
									fit: BoxFit.contain,
								),
							),
						),
						const SizedBox(height: 8),
						_NameBadge(pokemon: pokemon),
					],
				),
			),
		);
	}
}

class _NameBadge extends StatelessWidget {
	const _NameBadge({required this.pokemon});
	final Pokemon pokemon;

	@override
	Widget build(BuildContext context) {
		final colors = pokemon.typeColors;
		return Container(
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(12),
			),
			padding: const EdgeInsets.all(2),
			child: Container(
				decoration: BoxDecoration(
					borderRadius: BorderRadius.circular(10),
							color: colors.length == 1 ? colors.first : null,
							gradient: colors.length > 1
									? LinearGradient(
											colors: [colors[0], colors[0], colors[1], colors[1]],
											stops: const [0.0, 0.5, 0.5, 1.0],
										)
									: null,
				),
				padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
				alignment: Alignment.center,
				child: Text(
					pokemon.name,
					maxLines: 1,
					overflow: TextOverflow.ellipsis,
					style: const TextStyle(
						color: Colors.white,
						fontWeight: FontWeight.bold,
					),
				),
			),
		);
	}
}

class _NotFoundCard extends StatelessWidget {
	const _NotFoundCard({required this.id});
	final int id;

	@override
	Widget build(BuildContext context) {
		return AspectRatio(
			aspectRatio: 1,
			child: Container(
				decoration: BoxDecoration(
					color: Colors.grey[200],
					borderRadius: BorderRadius.circular(12),
					boxShadow: const [
						BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
					],
				),
				padding: const EdgeInsets.all(8),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						const Icon(Icons.image_not_supported_outlined, size: 32, color: Colors.black38),
						const SizedBox(height: 8),
						Text('Pokémon $id no encontrado', style: const TextStyle(color: Colors.black54)),
					],
				),
			),
		);
	}
}

