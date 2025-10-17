import 'package:flutter/material.dart';

class AbilitiesScreen extends StatelessWidget {
  const AbilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abilities')),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 6 / 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(2),
              child: ListTile(
                title: Text("Adaptability"),
                subtitle: Text(
                  'Powers up moves of the same type as the Pokemon.',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(2),
              child: ListTile(
                title: Text("Arena Trap"),
                subtitle: Text('Prevents opposing Pokémon from fleeing.'),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(2),
              child: ListTile(
                title: Text("Air Lock"),
                subtitle: Text('Eliminates the effects of weather.'),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(2),
              child: ListTile(
                title: Text("Analytic"),
                subtitle: Text(
                  'Boosts move power when the Pokémon moves last.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
