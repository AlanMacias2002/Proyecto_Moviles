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

  // Obtiene sólo los tipos de un Pokémon (más liviano que traer todo el detalle)
  Future<List<String>> getPokemonTypesByUrl(String url) async {
    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode != 200) return [];
      final data = jsonDecode(resp.body);
      final List types = data["types"] as List? ?? [];
      return types.map((t) => t["type"]["name"] as String).toList();
    } catch (e) {
      return [];
    }
  }

  // Obtiene el conjunto de IDs de Pokémon que pertenecen a un tipo dado
  // usando el endpoint /type/{type} (mucho más eficiente para filtrar por tipo)
  Future<Set<int>> getPokemonIdsByType(String typeSlug) async {
    try {
      final resp = await http.get(Uri.parse("$baseUrl/type/$typeSlug"));
      if (resp.statusCode != 200) return <int>{};
      final data = jsonDecode(resp.body);
      final List list = data["pokemon"] as List? ?? [];
      final ids = list.map<int>((entry) {
        final url = entry["pokemon"]["url"] as String;
        // extraer el ID de la URL
        return int.parse(url.split('/').where((s) => s.isNotEmpty).last);
      }).toSet();
      return ids;
    } catch (_) {
      return <int>{};
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
      "stats": data["stats"],
      "species": data["species"],
      "encounters": data["location_area_encounters"],
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

  Future<List<Map<String, dynamic>>> getAbilityList() async {
    const url = "https://pokeapi.co/api/v2/ability?limit=50";
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) throw Exception("Error loading abilities");

    final data = jsonDecode(resp.body);
    final List results = data["results"];
    return results.map((a) => {"name": a["name"], "url": a["url"]}).toList();
  }

  Future<Map<String, dynamic>> getAbilityDetail(String url) async {
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) throw Exception("Error loading ability detail");

    final detailData = jsonDecode(resp.body);
    final effectEntries = detailData["effect_entries"] as List;
    final englishEntry = effectEntries.firstWhere(
      (entry) => entry["language"]["name"] == "en",
      orElse: () => {"short_effect": "No description available"},
    );

    return {
      "name": detailData["name"],
      "short_effect": englishEntry["short_effect"],
      "pokemon": detailData["pokemon"],
    };
  }
}
