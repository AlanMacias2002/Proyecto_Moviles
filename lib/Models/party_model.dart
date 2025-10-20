import 'package:proyecto_moviles/Models/pokemons.dart';

// Formato del equipo: batallas individuales (1v1) o dobles (2v2)
enum BattleFormat { v1v1, v2v2 }

// Estilo/estrategia del equipo
enum TeamStyle { defensivo, agresivo, libre, sinAsignar }

class Party {
	Party({
		required this.name,
		required this.format,
		required this.style,
		List<Pokemon>? members,
	}) : members = List<Pokemon>.from(members ?? const []) {
		if (this.members.length > 6) {
			throw ArgumentError('Una party no puede tener más de 6 Pokémon');
		}
	}

	final String name;
	final BattleFormat format;
	final TeamStyle style;
	final List<Pokemon> members; // 0..6

	bool get isFull => members.length >= 6;

	void addPokemon(Pokemon p) {
		if (members.length >= 6) {
			throw StateError('La party ya tiene 6 Pokémon');
		}
		members.add(p);
	}

	void removePokemonById(int id) {
		members.removeWhere((p) => p.id == id);
	}

	factory Party.fromJson(Map<String, dynamic> json) => Party(
				name: json['name'] as String,
				format: _formatFromString(json['format'] as String),
				style: _styleFromString(json['style'] as String),
				members: ((json['members'] as List?) ?? const [])
						.whereType<Map<String, dynamic>>()
						.map(Pokemon.fromJson)
						.toList(),
			);

	Map<String, dynamic> toJson() => {
				'name': name,
				'format': format.name,
				'style': style.name,
				'members': members.map((p) => p.toJson()).toList(),
			};
}

BattleFormat _formatFromString(String value) {
	switch (value.trim().toLowerCase()) {
		case '1v1':
		case 'v1v1':
		case 'singles':
			return BattleFormat.v1v1;
		case '2v2':
		case 'v2v2':
		case 'doubles':
			return BattleFormat.v2v2;
		default:
			throw ArgumentError('Formato desconocido: $value');
	}
}

TeamStyle _styleFromString(String value) {
	switch (value.trim().toLowerCase()) {
		case 'defensivo':
		case 'defensive':
			return TeamStyle.defensivo;
		case 'agresivo':
		case 'aggressive':
			return TeamStyle.agresivo;
		case 'libre':
		case 'libre de restricciones':
		case 'free':
			return TeamStyle.libre;
		case 'sinasignar':
		case 'sin asignar':
		case 'unassigned':
			return TeamStyle.sinAsignar;
		default:
			throw ArgumentError('Estilo de equipo desconocido: $value');
	}
}

