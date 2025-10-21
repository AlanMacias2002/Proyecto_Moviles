import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Models/party_model.dart';
import 'package:proyecto_moviles/TestData/Data.dart';
import 'package:proyecto_moviles/Widgets/party.dart';
import 'package:proyecto_moviles/Screens/new_edit_partyScreen.dart';
import 'package:proyecto_moviles/Screens/QrScreen.dart';

class PartiesScreen extends StatelessWidget {
	const PartiesScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final demoParty = Party(
			name: 'Equipo de prueba',
			format: BattleFormat.v1v1,
			style: TeamStyle.agresivo,
			members: samplePokemons,
		);

			return Scaffold(
				appBar: AppBar(
					title: const Text('Parties'),
					actions: [
						// Botón QR (a la izquierda del '+')
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
			body: ListView(
				padding: const EdgeInsets.symmetric(vertical: 12),
				children: [
					PartyCard(
						party: demoParty,
									onTap: () {
										Navigator.of(context).push(
											MaterialPageRoute(
												builder: (_) => NewEditPartyScreen(party: demoParty),
											),
										);
									},
					),
				],
			),
		);
	}
}

