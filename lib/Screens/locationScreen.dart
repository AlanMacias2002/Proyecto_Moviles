import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final List<Map<String, dynamic>> metapodLocations = const [
    {
      'generation': 'Generation I',
      'games': ['Red', 'Blue', 'Yellow'],
      'locations': ['Viridian Forest', 'Routes 24 and 25'],
    },
    {
      'generation': 'Generation II',
      'games': ['Gold', 'Silver', 'Crystal'],
      'locations': [
        'Routes 2, 30, 31, 34–39',
        'Ilex Forest',
        'National Park (Bug-Catching Contest)',
        'Lake of Rage (Headbutt trees)',
        'Azalea Town'
      ],
    },
    {
      'generation': 'Generation III',
      'games': ['FireRed', 'LeafGreen'],
      'locations': ['Viridian Forest', 'Routes 24 and 25', 'Pattern Bush'],
    },
    {
      'generation': 'Generation IV',
      'games': ['HeartGold', 'SoulSilver'],
      'locations': ['Routes 2, 30', 'Ilex Forest', 'National Park'],
    },
    {
      'generation': 'Generation VI',
      'games': ['X', 'Y'],
      'locations': ['Central Kalos'],
    },
    {
      'generation': 'Generation VII',
      'games': ['Sun', 'Moon', 'Ultra Sun', 'Ultra Moon'],
      'locations': ['Alola Dex #0018'],
    },
    {
      'generation': 'Generation VIII',
      'games': ['Sword', 'Shield'],
      'locations': ['Galar Dex #0014'],
    },
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metapod Locations'),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList.radio(
          expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 4),
          initialOpenPanelValue: _expandedIndex,
          children: metapodLocations.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return ExpansionPanelRadio(
              value: index,
              headerBuilder: (context, isExpanded) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    title: Text(data['generation']),
                    subtitle: Text('Games: ${data['games'].join(', ')}'),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data['locations']
                      .map<Widget>((loc) => Container(
                            alignment: Alignment.centerLeft,
                            child: Text('• $loc'),
                          ))
                      .toList(),
                )
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
