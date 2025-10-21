import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Models/pokemons.dart';
import 'package:proyecto_moviles/Models/party_model.dart';

class PartyCard extends StatelessWidget {
  final Party party;
  final VoidCallback? onTap;

  const PartyCard({
    super.key,
    required this.party,
    this.onTap,
  });

  IconData _getStyleIcon(TeamStyle style) {
    switch (style) {
      case TeamStyle.defensivo:
        return Icons.security; 
      case TeamStyle.agresivo:
        return Icons.flash_on; 
      case TeamStyle.libre:
        return Icons.free_breakfast; 
      case TeamStyle.sinAsignar:
      default:
        return Icons.help_outline;
    }
  }

  String _formatText(BattleFormat format) {
    switch (format) {
      case BattleFormat.v1v1:
        return '1v1';
      case BattleFormat.v2v2:
        return '2v2';
    }
  }

  Color _styleColor(TeamStyle style) {
    switch (style) {
      case TeamStyle.defensivo:
        return Colors.blueAccent;
      case TeamStyle.agresivo:
        return Colors.redAccent;
      case TeamStyle.libre:
        return Colors.purpleAccent;
      case TeamStyle.sinAsignar:
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 238, 238),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  party.name.isEmpty ? "Unnamed team" : party.name,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _formatText(party.format),
                      style: const TextStyle(
                        color: Color.fromARGB(179, 0, 0, 0),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _getStyleIcon(party.style),
                      color: _styleColor(party.style),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: List.generate(6, (index) {
                if (index < party.members.length) {
                  final pokemon = party.members[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        pokemon.imageUrl, 
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.error, color: Colors.redAccent, size: 36),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(60, 9, 9, 9)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
