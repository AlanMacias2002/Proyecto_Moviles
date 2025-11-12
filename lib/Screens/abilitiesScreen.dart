import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Services/pokeapi-service.dart';
import 'abilityDetailScreen.dart';

class AbilitiesScreen extends StatefulWidget {
  const AbilitiesScreen({super.key});

  @override
  State<AbilitiesScreen> createState() => _AbilitiesScreenState();
}

class _AbilitiesScreenState extends State<AbilitiesScreen> {
  final PokeApiService api = PokeApiService();
  late Future<List<Map<String, dynamic>>> futureList;

  @override
  void initState() {
    super.initState();
    futureList = api.getAbilityList();
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final abilities = snapshot.data ?? [];
          if (abilities.isEmpty) {
            return const Center(child: Text("No abilities found"));
          }

          return ListView.separated(
            itemCount: abilities.length,
            separatorBuilder: (_, __) =>
                Divider(color: isDark ? Colors.white24 : Colors.grey.shade300),
            itemBuilder: (context, index) {
              final ability = abilities[index];
              return ListTile(
                title: Text(
                  ability["name"].toString().toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  // carga el detalle solo cuando el usuario toca
                  final detail = await api.getAbilityDetail(ability["url"]);
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AbilityDetailScreen(ability: detail),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
