import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  final Map<String, dynamic> pokemon;

  const LocationScreen({super.key, required this.pokemon});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<Map<String, dynamic>> encounterLocations = [];
  int? _expandedIndex;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadEncounters();
  }

  Future<void> loadEncounters() async {
    final url = widget.pokemon['encounters'];
    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode != 200) return;

      final data = jsonDecode(resp.body) as List;
      final parsed = <Map<String, dynamic>>[];

      for (final area in data) {
        final locationName = area['location_area']['name'].replaceAll('-', ' ');
        final versionDetails = area['version_details'] as List;

        final versions = versionDetails.map((v) {
          final version = v['version']['name'];
          final encounters = (v['encounter_details'] as List).map((e) {
            final method = e['method']['name'];
            final minLevel = e['min_level'];
            final maxLevel = e['max_level'];
            final chance = e['chance'];
            final conditions = (e['condition_values'] as List)
                .map((c) => c['name'].replaceAll('-', ' '))
                .toList();

            return {
              'method': method,
              'min_level': minLevel,
              'max_level': maxLevel,
              'chance': chance,
              'conditions': conditions,
            };
          }).toList();

          return {
            'version': version,
            'encounters': encounters,
          };
        }).toList();

        parsed.add({
          'location': locationName,
          'versions': versions,
        });
      }

      setState(() {
        encounterLocations = parsed;
        loading = false;
      });
    } catch (e) {
      debugPrint('Error loading encounters: $e');
      setState(() => loading = false);
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encounter Locations'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : encounterLocations.isEmpty
              ? const Center(child: Text('No encounter data found.'))
              : SingleChildScrollView(
                  child: ExpansionPanelList.radio(
                    expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 4),
                    initialOpenPanelValue: _expandedIndex,
                    children: encounterLocations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      return ExpansionPanelRadio(
                        value: index,
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            leading: const Icon(Icons.place, color: Colors.green),
                            title: Text(
                              _capitalize(data['location']),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Versions: ${data['versions'].map((v) => _capitalize(v['version'])).join(', ')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: data['versions'].map<Widget>((v) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🕹️ ${_capitalize(v['version'])}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ...v['encounters'].map<Widget>((e) {
                                    final conditions = (e['conditions'] as List).join(', ');
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                                      child: Text(
                                        '• ${_capitalize(e['method'])} | Lv ${e['min_level']}-${e['max_level']} | 🎯 ${e['chance']}%${conditions.isNotEmpty ? ' | ⏱️ $conditions' : ''}',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 8),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
