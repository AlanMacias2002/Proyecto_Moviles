import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Services/pokeapi-service.dart';

class MovesScreen extends StatefulWidget {
  final Map<String, dynamic>? pokemon;

  const MovesScreen({super.key, this.pokemon});

  @override
  State<MovesScreen> createState() => _MovesScreenState();
}

class _MovesScreenState extends State<MovesScreen> {
  final pokeApi = PokeApiService();
  List<Map<String, dynamic>> moves = [];
  List<Map<String, dynamic>> filteredMoves = [];

  bool loading = true;
  String query = "";

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMoves();

    searchController.addListener(() {
      setState(() {
        query = searchController.text.trim().toLowerCase();
        applySearch();
      });
    });
  }

  Future<void> loadMoves() async {
    try {
      List<Map<String, dynamic>> data = [];

      if (widget.pokemon != null) {
        final nameOrId =
            widget.pokemon!['name'] ?? widget.pokemon!['id'].toString();
        data = await pokeApi.getPokemonMoves(nameOrId);
      } else {
        data = await pokeApi.getAllMoves();
      }

      setState(() {
        moves = List<Map<String, dynamic>>.from(data);
        filteredMoves = moves;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      debugPrint('Error cargando moves: $e');
    }
  }

  void applySearch() {
    if (query.isEmpty) {
      filteredMoves = moves;
    } else {
      filteredMoves = moves.where((m) {
        final name = m["name"]?.toString().toLowerCase() ?? "";
        final type = m["type"]?.toString().toLowerCase() ?? "";
        final dmg = m["damage_class"]?.toString().toLowerCase() ?? "";
        return name.contains(query) ||
            type.contains(query) ||
            dmg.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Moves')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Moves')),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // -------------------------------
            //     🔍 SEARCHBAR
            // -------------------------------
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Buscar movimiento...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor.withOpacity(0.9),
              ),
            ),

            const SizedBox(height: 14),

            // -------------------------------
            //     LISTA DE MOVIMIENTOS
            // -------------------------------
            Expanded(
              child: ListView.separated(
                itemCount: filteredMoves.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 14), // espacio entre items
                itemBuilder: (context, index) {
                  final move = filteredMoves[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      title: Text(
                        move["name"]?.toString().toUpperCase() ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            move["short_effect"]?.toString() ?? '—',
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "${move["power"]?.toString() ?? '—'}  •  ${move["accuracy"]?.toString() ?? '—'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // TYPE CHIP
                              Chip(
                                label: Text(
                                  move["type"]?.toString().toUpperCase() ?? '—',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: _typeColor(
                                  move["type"]?.toString(),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),

                              const SizedBox(width: 8),

                              // DAMAGE CLASS CHIP
                              Chip(
                                label: Text(
                                  move["damage_class"]
                                          ?.toString()
                                          .toUpperCase() ??
                                      '—',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: _damageClassColor(
                                  move["damage_class"]?.toString(),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        // Aquí puedes navegar al detalle de un movimiento
                      },
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

  Color? _typeColor(String? type) {
    if (type == null) return Colors.grey[700];
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.red[600];
      case 'water':
        return Colors.blue[600];
      case 'grass':
        return Colors.green[600];
      case 'electric':
        return Colors.yellow[800];
      case 'ground':
        return Colors.brown[600];
      case 'psychic':
        return Colors.purple[600];
      case 'ice':
        return Colors.cyan[400];
      case 'dragon':
        return Colors.indigo[700];
      case 'dark':
        return Colors.black87;
      case 'fairy':
        return Colors.pink[300];
      case 'fighting':
        return Colors.orange[700];
      case 'rock':
        return Colors.brown;
      case 'ghost':
        return Colors.indigo[900];
      default:
        return Colors.grey[700];
    }
  }

  Color? _damageClassColor(String? cls) {
    if (cls == null) return Colors.blue[700];
    switch (cls.toLowerCase()) {
      case 'physical':
        return Colors.orange[700];
      case 'special':
        return Colors.blue[700];
      case 'status':
        return Colors.grey[600];
      default:
        return Colors.blue[700];
    }
  }
}
