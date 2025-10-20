import 'package:proyecto_moviles/Models/pokemons.dart';

// Ejemplos de Pokémon para pruebas iniciales.
// Reemplaza '<PON_AQUI_LA_URL>' por la URL de la imagen correspondiente.

final List<Pokemon> samplePokemons = [
	Pokemon(
		id: 1,
		name: 'Bulbasaur',
		types: const [PokemonType.grass, PokemonType.poison],
		imageUrl: 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/001.png',
	),
	Pokemon(
		id: 25,
		name: 'Pikachu',
		types: const [PokemonType.electric],
		imageUrl: 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/025.png',
	),
	Pokemon(
		id: 6,
		name: 'Charizard',
		types: const [PokemonType.fire, PokemonType.flying],
		imageUrl: 'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/006.png',
	),
];

