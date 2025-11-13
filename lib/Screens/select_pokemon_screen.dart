import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Models/pokemons.dart';
import 'package:proyecto_moviles/Services/pokeapi-service.dart';

/// Pantalla para seleccionar un Pokémon y devolverlo al caller.
class SelectPokemonScreen extends StatefulWidget {
  const SelectPokemonScreen({super.key});

  @override
  State<SelectPokemonScreen> createState() => _SelectPokemonScreenState();
}

class _SelectPokemonScreenState extends State<SelectPokemonScreen> {
  final _service = PokeApiService();
  late final Future<List<Map<String, dynamic>>> _future;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  String _selectedType = 'Todos';
  String _selectedGen = 'Todas';
  bool _loadingTypeData = false;
  final Map<String, Set<int>> _typeCache = {}; // slug -> set ids

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
    _future = _service.getAllPokemon();
    _searchCtrl.addListener(() {
      final q = _searchCtrl.text.trim().toLowerCase();
      if (q != _query) setState(() => _query = q);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Pokémon'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos'));
          }

            var pokes = snapshot.data!;

            // filtro nombre
            pokes = _query.isEmpty
                ? pokes
                : pokes
                    .where((p) => (p['name'] as String)
                        .toLowerCase()
                        .contains(_query))
                    .toList();

            // filtro generación
            if (_selectedGen != 'Todas') {
              final range = _genRanges[_selectedGen]!;
              pokes = pokes
                  .where((p) => (p['id'] as int) >= range[0] && (p['id'] as int) <= range[1])
                  .toList();
            }

            // filtro tipo
            if (_selectedType != 'Todos') {
              final slug = _typeSlugByLabel[_selectedType] ?? '';
              if (slug.isNotEmpty) {
                if (!_typeCache.containsKey(slug) && !_loadingTypeData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    if (!mounted) return;
                    setState(() => _loadingTypeData = true);
                    final ids = await _service.getPokemonIdsByType(slug);
                    if (mounted) {
                      setState(() {
                        _typeCache[slug] = ids;
                        _loadingTypeData = false;
                      });
                    }
                  });
                }
                final ids = _typeCache[slug];
                if (ids != null && ids.isNotEmpty) {
                  pokes = pokes.where((p) => ids.contains(p['id'] as int)).toList();
                } else {
                  pokes = [];
                }
              }
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Nombre del Pokémon',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      suffixIcon: _query.isEmpty
                          ? const Icon(Icons.search)
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchCtrl.clear(),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedType,
                          isExpanded: true,
                          decoration: _filterDecoration('Tipo'),
                          items: _typeSlugByLabel.keys
                              .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedType = v ?? 'Todos'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedGen,
                          isExpanded: true,
                          decoration: _filterDecoration('Generación'),
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
                          onChanged: (v) => setState(() => _selectedGen = v ?? 'Todas'),
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
                  if (pokes.isEmpty)
                    const Expanded(child: Center(child: Text('Sin resultados')))
                  else
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: pokes.length,
                        itemBuilder: (context, index) {
                          final data = pokes[index];
                          return InkWell(
                            onTap: () async {
                              final detail = await _service.getPokemonDetail(data['url']);
                              if (!mounted) return;
                              // construir objeto Pokemon
                              final types = (detail['types'] as List)
                                  .whereType<String>()
                                  .map((t) => PokemonType.values.firstWhere((e) => e.name == t))
                                  .toList();
                              // Usar siempre el mismo sprite (consistencia con Pokédex y equipos)
                              final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${detail['id']}.png';
                              final pokemon = Pokemon(
                                id: detail['id'] as int,
                                name: detail['name'] as String,
                                types: types,
                                imageUrl: imageUrl,
                              );
                              Navigator.pop(context, pokemon);
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${data['id']}.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, s) => const Icon(Icons.error),
                                  ),
                                ),
                                Text(
                                  data['name'],
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

  InputDecoration _filterDecoration(String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }
}
