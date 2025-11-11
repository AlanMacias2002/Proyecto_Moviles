import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EvolutionScreen extends StatefulWidget {
  final Map<String, dynamic> pokemon;

  const EvolutionScreen({super.key, required this.pokemon});

  @override
  State<EvolutionScreen> createState() => _EvolutionScreenState();
}

class _EvolutionScreenState extends State<EvolutionScreen> {
  List<Map<String, dynamic>> evolutionSteps = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadEvolutionChain();
  }

  Future<void> loadEvolutionChain() async {
    try {
      final speciesUrl = widget.pokemon['species']['url'];
      final speciesResp = await http.get(Uri.parse(speciesUrl));
      if (speciesResp.statusCode != 200) return;

      final speciesData = jsonDecode(speciesResp.body);
      final evoChainUrl = speciesData['evolution_chain']['url'];

      final evoResp = await http.get(Uri.parse(evoChainUrl));
      if (evoResp.statusCode != 200) return;

      final evoData = jsonDecode(evoResp.body);
      final chain = evoData['chain'];

      final steps = <Map<String, dynamic>>[];
      var current = chain;

      while (current['evolves_to'] != null && current['evolves_to'].isNotEmpty) {
        final next = current['evolves_to'][0];
        final fromName = current['species']['name'];
        final toName = next['species']['name'];
        final level = next['evolution_details']?[0]?['min_level'] ?? 0;

        steps.add({
          'from': _capitalize(fromName),
          'to': _capitalize(toName),
          'level': level,
          'fromImageUrl': _getImageUrlFromSpecies(current['species']['url']),
          'toImageUrl': _getImageUrlFromSpecies(next['species']['url']),
        });

        current = next;
      }

      setState(() {
        evolutionSteps = steps;
        loading = false;
      });
    } catch (e) {
      debugPrint('Error loading evolution chain: $e');
      setState(() => loading = false);
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  String _getImageUrlFromSpecies(String speciesUrl) {
    final uri = Uri.parse(speciesUrl);
    final segments = uri.pathSegments;
    final id = segments.where((s) => s.isNotEmpty).last;
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evolutions')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Evolutions',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ...evolutionSteps.map((step) => EvolutionRow(
                        from: step['from'],
                        to: step['to'],
                        level: step['level'],
                        fromImageUrl: step['fromImageUrl'],
                        toImageUrl: step['toImageUrl'],
                      )),
                ],
              ),
      ),
    );
  }
}


class EvolutionRow extends StatelessWidget {
  final String from;
  final String to;
  final int level;
  final String fromImageUrl;
  final String toImageUrl;

  const EvolutionRow({
    super.key,
    required this.from,
    required this.to,
    required this.level,
    required this.fromImageUrl,
    required this.toImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Image.network(fromImageUrl, width: 80),
              Text(from),
            ],
          ),
          Column(
            children: [
              Text('Level $level'),
              const Icon(Icons.arrow_forward),
            ],
          ),
          Column(
            children: [
              Image.network(toImageUrl, width: 80),
              Text(to),
            ],
          ),
        ],
      ),
    );
  }
}

