import 'package:flutter/material.dart';

enum PokemonType {
  normal,
  fire,
  water,
  electric,
  grass,
  ice,
  fighting,
  poison,
  ground,
  flying,
  psychic,
  bug,
  rock,
  ghost,
  dragon,
  dark,
  steel,
  fairy,
}

class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final List<PokemonType> types;
  final String imageUrl;

  Color get primaryColor => pokemonTypeColor(types.first);

  Color get secondaryColor =>
      types.length > 1 ? pokemonTypeColor(types[1]) : primaryColor;

  List<Color> get typeColors =>
      types.map((t) => pokemonTypeColor(t)).toList(growable: false);

  LinearGradient get typeGradient => typeColors.length == 1
      ? LinearGradient(colors: [primaryColor, primaryColor.withOpacity(0.8)])
      : LinearGradient(colors: typeColors);

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
    id: json['id'] as int,
    name: json['name'] as String,
    types: _parseTypes(json),
    imageUrl: json['imageUrl'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'types': types.map((t) => t.name).toList(),
    'imageUrl': imageUrl,
  };
}

PokemonType _typeFromString(String value) {
  final normalized = value.trim().toLowerCase();
  return PokemonType.values.firstWhere(
    (t) => t.name == normalized,
    orElse: () => throw ArgumentError('Unknown PokemonType: $value'),
  );
}

List<PokemonType> _parseTypes(Map<String, dynamic> json) {
  if (json['types'] is List) {
    final list = (json['types'] as List)
        .whereType<String>()
        .map(_typeFromString)
        .toList();
    if (list.isEmpty || list.length > 2) {
      throw ArgumentError(
        'A Pokémon must have 1 or 2 types. Got: ${list.length}',
      );
    }
    return list;
  }
  if (json['type'] is String) {
    return [_typeFromString(json['type'] as String)];
  }
  throw ArgumentError('Missing types for Pokémon JSON');
}

Color pokemonTypeColor(PokemonType type) {
  switch (type) {
    case PokemonType.normal:
      return Colors.brown[300]!;
    case PokemonType.fire:
      return Colors.redAccent;
    case PokemonType.water:
      return Colors.blueAccent;
    case PokemonType.electric:
      return Colors.amber[700]!;
    case PokemonType.grass:
      return Colors.green;
    case PokemonType.ice:
      return Colors.cyan[300]!;
    case PokemonType.fighting:
      return Colors.orange[800]!;
    case PokemonType.poison:
      return Colors.purple;
    case PokemonType.ground:
      return Colors.brown;
    case PokemonType.flying:
      return Colors.indigo;
    case PokemonType.psychic:
      return Colors.pinkAccent;
    case PokemonType.bug:
      return Colors.lightGreen[700]!;
    case PokemonType.rock:
      return Colors.brown[600]!;
    case PokemonType.ghost:
      return Colors.deepPurple;
    case PokemonType.dragon:
      return Colors.indigoAccent;
    case PokemonType.dark:
      return Colors.blueGrey[800]!;
    case PokemonType.steel:
      return Colors.blueGrey;
    case PokemonType.fairy:
      return Colors.pink[300]!;
  }
}
