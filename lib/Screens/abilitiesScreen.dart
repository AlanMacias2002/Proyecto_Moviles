import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Services/pokeapi-service.dart';

class AbilitiesScreen extends StatefulWidget {
  const AbilitiesScreen({super.key});

  @override
  State<AbilitiesScreen> createState() => _AbilitiesScreenState();
}

class _AbilitiesScreenState extends State<AbilitiesScreen> {
  final pokeApi = PokeApiService();
  List<Map<String, dynamic>> abilities = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAbilities();
  }

  Future<void> loadAbilities() async {
    try {
      final data = await pokeApi.getAllAbilities();
      setState(() {
        // aseguramos el tipo correcto
        abilities = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      debugPrint('Error cargando abilities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Abilities')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Abilities')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: abilities.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final ability = abilities[index];

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
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
                  ability["name"]?.toString().toUpperCase() ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    ability["short_effect"]?.toString() ?? '—',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                onTap: null, // sin acción extra
              ),
            );
          },
        ),
      ),
    );
  }
}
