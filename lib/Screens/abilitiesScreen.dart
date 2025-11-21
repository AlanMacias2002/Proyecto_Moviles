import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Services/pokeapi-service.dart';
import 'abilityDetailScreen.dart';

class AbilitiesScreen extends StatefulWidget {
  const AbilitiesScreen({super.key});

  @override
  State<AbilitiesScreen> createState() => _AbilitiesScreenState();
}

class _AbilitiesScreenState extends State<AbilitiesScreen> {
  final _pokemonService = PokeApiService();
  late final Future<List<Map<String, dynamic>>> _future;

  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();

    _future = _pokemonService.getAbilityList();

    _searchController.addListener(() {
      final q = _searchController.text.trim().toLowerCase();
      if (q != _query) setState(() => _query = q);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Abilities"),
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[200],
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar habilidad',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _query.isEmpty
                    ? const Icon(Icons.search)
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      ),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text("No data loaded"));
                }

                List<Map<String, dynamic>> abilities = snapshot.data!;

                if (_query.isNotEmpty) {
                  abilities = abilities
                      .where(
                        (a) =>
                            a["name"].toString().toLowerCase().contains(_query),
                      )
                      .toList();
                }

                if (abilities.isEmpty) {
                  return const Center(child: Text("No abilities found"));
                }

                return ListView.builder(
                  itemCount: abilities.length,
                  itemBuilder: (context, index) {
                    final ability = abilities[index];

                    // ⭐⭐ CARD MATERIAL YOU ⭐⭐
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: isDark ? Colors.grey[850] : Colors.grey[100],
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        leading: Icon(
                          Icons.bolt,
                          size: 28,
                          color: isDark
                              ? Colors.yellow[300]
                              : Colors.blueAccent,
                        ),
                        title: Text(
                          ability["name"].toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final detail = await _pokemonService.getAbilityDetail(
                            ability["url"],
                          );

                          if (!context.mounted) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AbilityDetailScreen(ability: detail),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
