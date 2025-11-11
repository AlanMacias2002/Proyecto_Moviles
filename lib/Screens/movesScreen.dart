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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMoves();
  }

  Future<void> loadMoves() async {
    try {
      List<Map<String, dynamic>> data = [];

      if (widget.pokemon != null) {
        final nameOrId = widget.pokemon!['name'] ?? widget.pokemon!['id'].toString();
        data = await pokeApi.getPokemonMoves(nameOrId);
      } else {
        data = await pokeApi.getAllMoves();
      }

      setState(() {
        moves = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      debugPrint('Error cargando moves: $e');
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
        child: ListView.separated(
          itemCount: moves.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: 14), // espacio entre items
          itemBuilder: (context, index) {
            final move = moves[index];

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
                    // descripción: puede ocupar 1 o 2+ líneas. permitimos wrap.
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
                        // power • accuracy
                        Text(
                          "${move["power"]?.toString() ?? '—'}  •  ${move["accuracy"]?.toString() ?? '—'}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 12),
                        // type chip
                        Chip(
                          label: Text(
                            move["type"]?.toString().toUpperCase() ?? '—',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: _typeColor(move["type"]?.toString()),
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                        // damage class chip
                        Chip(
                          label: Text(
                            move["damage_class"]?.toString().toUpperCase() ??
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
                  // aquí puedes navegar a detail (getMoveDetail)
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // helper simple para color por tipo (puedes extender)
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

  // helper para color según damage class
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
