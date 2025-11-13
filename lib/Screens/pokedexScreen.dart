import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Services/pokeapi-service.dart'; 
import 'package:proyecto_moviles/Widgets/pokemon.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final _pokemonService = PokeApiService();
  late final Future<List<Map<String, dynamic>>> _future;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedType = 'Todos';
  String _selectedGen = 'Todas';
  bool _loadingTypeData = false; 
  final Map<String, Set<int>> _typeToIdsCache = {};

  
  static const Map<String, String> _typeSlugByLabel = {
    'Todos': '',
    'Normal': 'normal',
    'Planta': 'grass',
    'Fuego': 'fire',
    'Agua': 'water',
    'Eléctrico': 'electric',
    'Hielo': 'ice',
    'Tierra': 'ground',
    'Roca': 'rock',
    'Lucha': 'fighting',
    'Veneno': 'poison',
    'Volador': 'flying',
    'Psíquico': 'psychic',
    'Bicho': 'bug',
    'Fantasma': 'ghost',
    'Dragón': 'dragon',
    'Siniestro': 'dark',
    'Acero': 'steel',
    'Hada': 'fairy',
  };

  
  static const Map<String, List<int>> _genRanges = {
    'Gen 1': [1, 151],
    'Gen 2': [152, 251],
    'Gen 3': [252, 386],
    'Gen 4': [387, 493],
    'Gen 5': [494, 649],
    'Gen 6': [650, 721],
    'Gen 7': [722, 809],
    'Gen 8': [810, 905],
    'Gen 9': [906, 1010],
  };

  @override
  void initState() {
    super.initState();
    _future = _pokemonService.getAllPokemon();
    _searchController.addListener(() {
      final q = _searchController.text.trim().toLowerCase();
      if (q != _query) {
        setState(() => _query = q);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay Pokémon'));
          }

          final allPokemons = snapshot.data!;
          List<Map<String, dynamic>> filteredPokemons = _query.isEmpty
              ? List<Map<String, dynamic>>.from(allPokemons)
              : allPokemons
                  .where((p) => (p['name'] as String)
                      .toLowerCase()
                      .contains(_query))
                  .toList();
          if (_selectedGen != 'Todas') {
            final range = _genRanges[_selectedGen]!;
            filteredPokemons = filteredPokemons
                .where((p) => (p['id'] as int) >= range[0] && (p['id'] as int) <= range[1])
                .toList();
          }

          if (_selectedType != 'Todos') {
            final slug = _typeSlugByLabel[_selectedType] ?? '';
            if (slug.isNotEmpty) {
              if (!_typeToIdsCache.containsKey(slug) && !_loadingTypeData) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (!mounted) return;
                  setState(() => _loadingTypeData = true);
                  final ids = await _pokemonService.getPokemonIdsByType(slug);
                  if (mounted) {
                    setState(() {
                      _typeToIdsCache[slug] = ids;
                      _loadingTypeData = false;
                    });
                  }
                });
              }

              final ids = _typeToIdsCache[slug];
              if (ids != null && ids.isNotEmpty) {
                filteredPokemons = filteredPokemons
                    .where((p) => ids.contains(p['id'] as int))
                    .toList();
              } else {
                filteredPokemons = const [];
              }
            }
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Nombre del Pokémon',
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
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: _query.isEmpty
                        ? const Icon(Icons.search)
                        : IconButton(
                            tooltip: 'Limpiar',
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          ),
                  ),
                  onChanged: (value) {
                    setState(() => _query = value.trim().toLowerCase());
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
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
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                        items: _typeSlugByLabel.keys
                            .map((label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val == null) return;
                          setState(() => _selectedType = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGen,
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
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.blue, width: 1.5),
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
                        onChanged: (val) {
                          if (val == null) return;
                          setState(() => _selectedGen = val);
                        },
                      ),
                    ),
                  ],
                ),
                if (_loadingTypeData)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
                const SizedBox(height: 12),
                // Grid de 3 columnas
                if (filteredPokemons.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text('Sin resultados'),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: filteredPokemons.length,
                      itemBuilder: (context, index) {
                        final p = filteredPokemons[index];
                        final imageUrl =
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${p['id']}.png";

                        return InkWell(
                          onTap: () async {
                            final pokemonDetails =
                                await _pokemonService.getPokemonDetail(p['url']);

                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PokemonWidget(pokemon: pokemonDetails),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                              Text(
                                p["name"],
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
