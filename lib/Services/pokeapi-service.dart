import 'dart:convert';
import 'package:http/http.dart' as http;

class PokeApiService {
  final baseUrl = "https://pokeapi.co/api/v2";

  Future<List<Map<String, dynamic>>> getAllPokemon() async {
    try {
      final resp = await http.get(Uri.parse("$baseUrl/pokemon?limit=2000"));
      if (resp.statusCode != 200) return [];

      final data = jsonDecode(resp.body);
      final results = (data["results"] as List)
          .map(
            (p) => {
              "name": p["name"],
              "url": p["url"],
              // sacar ID de la URL para usar en imagenes
              "id": int.parse(
                p["url"].toString().split('/').where((s) => s.isNotEmpty).last,
              ),
              // URL de la imagen del sprite
              "imageUrl":
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${int.parse(p["url"].toString().split('/').where((s) => s.isNotEmpty).last)}.png",
            },
          )
          .toList();

      return results;
    } catch (e) {
      print("Error getAllPokemon: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> getPokemonDetail(String url) async {
    final resp = await http.get(Uri.parse(url));
    final data = jsonDecode(resp.body);

    final speciesResp = await http.get(Uri.parse(data["species"]["url"]));
    final speciesData = jsonDecode(speciesResp.body);

    final flavor = (speciesData["flavor_text_entries"] as List).firstWhere(
      (f) => f["language"]["name"] == "es",
      orElse: () => speciesData["flavor_text_entries"][0],
    );

    return {
      "id": data["id"],
      "name": data["name"],
      "types": data["types"].map((t) => t["type"]["name"]).toList(),
      "moves": data["moves"].map((m) => m["move"]["name"]).toList(),
      "image": data["sprites"]["other"]["official-artwork"]["front_default"],
      "abilities": data["abilities"].map((a) => a["ability"]["name"]).toList(),
      "description": flavor["flavor_text"],
      "audio": null, // pokeapi no trae cries en audio directamente
    };
  }

  Future<List<Map<String, dynamic>>> getAllMoves() async {
    final baseUrl = "https://pokeapi.co/api/v2";
    try {
      // 1. Traer lista de movimientos
      final resp = await http.get(Uri.parse("$baseUrl/move?limit=500"));
      if (resp.statusCode != 200) return [];

      final moves = (jsonDecode(resp.body)["results"] as List);

      // 2. Traer detalles concurrentemente
      const batchSize = 20; // evita saturar la API
      List<Map<String, dynamic>> allMoves = [];

      for (var i = 0; i < moves.length; i += batchSize) {
        final batch = moves.skip(i).take(batchSize).toList();

        final futures = batch.map((m) async {
          final detailResp = await http.get(Uri.parse(m["url"]));
          if (detailResp.statusCode != 200) return null;

          final moveRes = jsonDecode(detailResp.body);

          String shortEffect = "-";
          if (moveRes["effect_entries"] != null) {
            final entryEn = (moveRes["effect_entries"] as List).firstWhere(
              (e) => e["language"]["name"] == "en",
              orElse: () => null,
            );
            if (entryEn != null) {
              shortEffect = entryEn["short_effect"] ?? entryEn["effect"] ?? "-";
            }
          }

          return {
            "name": moveRes["name"] ?? "-",
            "accuracy": moveRes["accuracy"] ?? "-",
            "power": moveRes["power"] ?? "-",
            "damage_class": moveRes["damage_class"]?["name"] ?? "-",
            "type": moveRes["type"]?["name"] ?? "-",
            "short_effect": shortEffect,
          };
        }).toList();

        allMoves.addAll(
          (await Future.wait(futures)).whereType<Map<String, dynamic>>(),
        );
      }

      return allMoves;
    } catch (e) {
      print("Error getAllMoves: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPokemonMoves(String nameOrId) async {
    final baseUrl = "https://pokeapi.co/api/v2";
    try {
      // 1. Traer los datos del Pokémon
      final resp = await http.get(Uri.parse("$baseUrl/pokemon/$nameOrId"));
      if (resp.statusCode != 200) return [];

      final pokemonData = jsonDecode(resp.body);

      final movesList = pokemonData["moves"] as List;
      if (movesList.isEmpty) return [];

      // 2. Traer detalles de cada movimiento (batch para no saturar la API)
      const batchSize = 20;
      List<Map<String, dynamic>> allMoves = [];

      for (var i = 0; i < movesList.length; i += batchSize) {
        final batch = movesList.skip(i).take(batchSize).toList();

        final futures = batch.map((m) async {
          final moveUrl = m["move"]["url"];
          final detailResp = await http.get(Uri.parse(moveUrl));
          if (detailResp.statusCode != 200) return null;

          final moveRes = jsonDecode(detailResp.body);

          // short effect EN
          String shortEffect = "-";
          if (moveRes["effect_entries"] != null) {
            final entryEn = (moveRes["effect_entries"] as List).firstWhere(
              (e) => e["language"]["name"] == "en",
              orElse: () => null,
            );
            if (entryEn != null) {
              shortEffect = entryEn["short_effect"] ?? entryEn["effect"] ?? "-";
            }
          }

          return {
            "name": moveRes["name"] ?? "-",
            "accuracy": moveRes["accuracy"] ?? "-",
            "power": moveRes["power"] ?? "-",
            "damage_class": moveRes["damage_class"]?["name"] ?? "-",
            "type": moveRes["type"]?["name"] ?? "-",
            "short_effect": shortEffect,
          };
        }).toList();

        allMoves.addAll(
          (await Future.wait(futures)).whereType<Map<String, dynamic>>(),
        );
      }

      return allMoves;
    } catch (e) {
      print("Error getPokemonMoves: $e");
      return [];
    }
  }

  Future<List<Map<String, String>>> getAllAbilities() async {
    try {
      final resp = await http.get(Uri.parse("$baseUrl/ability?limit=2000"));
      if (resp.statusCode != 200) return [];

      final data = jsonDecode(resp.body);
      final results = (data["results"] as List).cast<Map<String, dynamic>>();

      // Hacer las llamadas a cada habilidad en paralelo
      final futures = results.map((ab) async {
        try {
          final abResp = await http.get(Uri.parse(ab["url"] as String));
          if (abResp.statusCode != 200) return null;

          final abData = jsonDecode(abResp.body) as Map<String, dynamic>;
          final effectEntries =
              (abData["effect_entries"] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              [];

          // Buscar la descripción en inglés
          final enEntry = effectEntries.firstWhere(
            (e) => e["language"]["name"] == "en",
            orElse: () => {"short_effect": "No description available"},
          );

          return {
            "name": ab["name"] as String? ?? "Unknown",
            "short_effect":
                enEntry["short_effect"] as String? ??
                "No description available",
          };
        } catch (_) {
          return null;
        }
      }).toList();

      final abilities = await Future.wait(futures);

      // Filtrar nulls
      return abilities.whereType<Map<String, String>>().toList();
    } catch (e) {
      print("Error getAllAbilities: $e");
      return [];
    }
  }
}
