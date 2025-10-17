import 'package:flutter/material.dart';

class MovesScreen extends StatelessWidget {
  const MovesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moves')),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 5 / 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            ListTile(
              title: const Text(
                "Absorb",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Drains half the damage inflicted to heal the user",
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text("20  •  100"),
                      const SizedBox(width: 8),
                      Chip(
                        label: const Text(
                          "GRASS",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green[600],
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 4),
                      Chip(
                        label: const Text(
                          "SPECIAL",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue[600],
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                "Flamethrower",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("May burn the target"),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text("90  •  100"),
                      const SizedBox(width: 8),
                      Chip(
                        label: const Text(
                          "FIRE",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red[600],
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 4),
                      Chip(
                        label: const Text(
                          "SPECIAL",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue[600],
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ListTile(
              title: const Text(
                "Earthquake",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Hits all adjacent Pokémon"),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text("100  •  100"),
                      const SizedBox(width: 8),
                      Chip(
                        label: const Text(
                          "GROUND",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.brown[600],
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 4),
                      Chip(
                        label: const Text(
                          "PHYSICAL",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.orange[600],
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                "Thunder Wave",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Paralyzes the target"),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text("—  •  90"),
                      const SizedBox(width: 8),
                      Chip(
                        label: const Text(
                          "ELECTRIC",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.yellow[700],
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 4),
                      Chip(
                        label: const Text(
                          "STATUS",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.grey[700],
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
