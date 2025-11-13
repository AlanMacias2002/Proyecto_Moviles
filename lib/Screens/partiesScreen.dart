import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Models/party_model.dart';
import 'package:proyecto_moviles/Screens/new_edit_partyScreen.dart';
import 'package:proyecto_moviles/Screens/QrScreen.dart';

class PartiesScreen extends StatelessWidget {
  const PartiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Party> parties = []; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QrScreen(),
                  ),
                );
              },
              child: Ink(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.qr_code_2, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NewEditPartyScreen(),
                  ),
                );
              },
              child: Ink(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.add, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: parties.isEmpty
          ? const Center(
              child: Text(
                'Sin equipos registrados',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: parties.length,
              itemBuilder: (context, index) {
                final party = parties[index];
                return ListTile(
                  title: Text(party.name.isEmpty ? 'Equipo ${index + 1}' : party.name),
                  subtitle: Text('${party.members.length} Pokémon'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NewEditPartyScreen(party: party),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

