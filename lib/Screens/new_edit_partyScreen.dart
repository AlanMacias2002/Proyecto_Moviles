import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Models/party_model.dart';
import 'package:proyecto_moviles/Models/pokemons.dart';
import 'package:proyecto_moviles/Screens/shareQrScreen.dart';
import 'package:proyecto_moviles/Screens/select_pokemon_screen.dart';
import 'package:proyecto_moviles/Services/party_repository.dart';

class NewEditPartyScreen extends StatefulWidget {
	const NewEditPartyScreen({super.key, this.party, this.partyId});

	final Party? party; // null = nueva, !null = editar
	final String? partyId; // id del documento en Firestore

	@override
	State<NewEditPartyScreen> createState() => _NewEditPartyScreenState();
}

class _NewEditPartyScreenState extends State<NewEditPartyScreen> {
	final _repo = PartyRepository();
	late final TextEditingController _nameCtrl;
	late BattleFormat _format;
	late TeamStyle _style;
	late final List<Pokemon> _members;
	bool _saving = false;
	bool _deleting = false;

	Future<void> _pickPokemon(int slotIndex) async {
		final selected = await Navigator.of(context).push<Pokemon>(
			MaterialPageRoute(
				builder: (_) => const SelectPokemonScreen(),
			),
		);
		if (selected != null) {
			setState(() {
				if (slotIndex < _members.length) {
					_members[slotIndex] = selected; // reemplaza
				} else if (_members.length < 6) {
					_members.add(selected); // agrega nuevo
				}
			});
		}
	}

	@override
	void initState() {
		super.initState();
		_nameCtrl = TextEditingController(text: widget.party?.name ?? '');
		_format = widget.party?.format ?? BattleFormat.v1v1;
		_style = widget.party?.style ?? TeamStyle.sinAsignar;
			_members = List<Pokemon>.from(widget.party?.members ?? const []);
	}

	@override
	void dispose() {
		_nameCtrl.dispose();
		super.dispose();
	}

	void _snack(String msg) {
		ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
	}

	Future<void> _save() async {
		if (_saving) return;
		if (_nameCtrl.text.trim().isEmpty) {
			_snack('Pon un nombre al equipo');
			return;
		}
		final party = Party(
			name: _nameCtrl.text.trim(),
			format: _format,
			style: _style,
			members: _members,
		);
		setState(() => _saving = true);
		try {
			if (widget.partyId == null) {
				await _repo.createParty(party);
				_snack('Equipo creado');
			} else {
				await _repo.updateParty(widget.partyId!, party);
				_snack('Cambios guardados');
			}
			if (mounted) Navigator.pop(context);
		} catch (e) {
			_snack('Error al guardar: $e');
		} finally {
			if (mounted) setState(() => _saving = false);
		}
	}

	Future<void> _delete() async {
		if (_deleting) return;
		final id = widget.partyId;
		if (id == null) return;
		final confirm = await showDialog<bool>(
					context: context,
					builder: (ctx) => AlertDialog(
						title: const Text('Eliminar equipo'),
						content: const Text('¿Seguro que quieres eliminar este equipo?'),
						actions: [
							TextButton(
								onPressed: () => Navigator.pop(ctx, false),
								child: const Text('Cancelar'),
							),
							TextButton(
								onPressed: () => Navigator.pop(ctx, true),
								child: const Text('Eliminar'),
							),
						],
					),
				) ??
				false;
		if (!confirm) return;
		setState(() => _deleting = true);
		try {
			await _repo.deleteParty(id);
			if (mounted) {
				Navigator.pop(context);
				ScaffoldMessenger.of(context).showSnackBar(
					const SnackBar(content: Text('Equipo eliminado')),
				);
			}
		} catch (e) {
			_snack('Error al eliminar: $e');
		} finally {
			if (mounted) setState(() => _deleting = false);
		}
	}

	@override
	Widget build(BuildContext context) {
		final isEdit = widget.party != null;
		return Scaffold(
			appBar: AppBar(
				title: Text(isEdit ? 'Editar equipo' : 'Nuevo equipo'),
				actions: [
							if (widget.partyId != null)
								IconButton(
									icon: const Icon(Icons.delete_outline),
									tooltip: 'Eliminar',
									onPressed: _deleting ? null : _delete,
								),
							if (isEdit)
								IconButton(
									icon: const Icon(Icons.qr_code_2),
									tooltip: 'QR',
									onPressed: widget.partyId == null
											? null
											: () {
													Navigator.of(context).push(
														MaterialPageRoute(
															builder: (_) => ShareQrScreen(partyId: widget.partyId!),
														),
													);
												},
								),
					IconButton(
						icon: const Icon(Icons.help_outline),
						onPressed: () => _snack('funcionammiento accion'),
					),
				],
			),
			body: SafeArea(
				child: ListView(
					padding: const EdgeInsets.all(16),
					children: [
						TextField(
							controller: _nameCtrl,
							decoration: const InputDecoration(
								labelText: 'Nombre del equipo',
								border: OutlineInputBorder(),
							),
							onSubmitted: (_) => _snack('funcionammiento accion'),
						),
						const SizedBox(height: 16),

						// Formato
						InputDecorator(
							decoration: const InputDecoration(
								labelText: 'Formato',
								border: OutlineInputBorder(),
							),
							child: DropdownButtonHideUnderline(
								child: DropdownButton<BattleFormat>(
									value: _format,
									items: const [
										DropdownMenuItem(value: BattleFormat.v1v1, child: Text('1v1')),
										DropdownMenuItem(value: BattleFormat.v2v2, child: Text('2v2')),
									],
									onChanged: (v) {
										if (v != null) setState(() => _format = v);
									},
								),
							),
						),
						const SizedBox(height: 16),

						// Estilo
						InputDecorator(
							decoration: const InputDecoration(
								labelText: 'Tipo de equipo',
								border: OutlineInputBorder(),
							),
							child: DropdownButtonHideUnderline(
								child: DropdownButton<TeamStyle>(
									value: _style,
									items: const [
										DropdownMenuItem(value: TeamStyle.defensivo, child: Text('Defensivo')),
										DropdownMenuItem(value: TeamStyle.agresivo, child: Text('Agresivo')),
										DropdownMenuItem(value: TeamStyle.libre, child: Text('Libre')),
										DropdownMenuItem(value: TeamStyle.sinAsignar, child: Text('Sin asignar')),
									],
									onChanged: (v) {
										if (v != null) setState(() => _style = v);
									},
								),
							),
						),
						const SizedBox(height: 16),

						// Miembros (solo cascarón con 6 slots)
						const Text('Miembros (máx. 6)'),
						const SizedBox(height: 8),
									Wrap(
									spacing: 8,
									runSpacing: 8,
									children: List.generate(6, (i) {
												if (i < _members.length) {
													final p = _members[i];
													return GestureDetector(
														onTap: () => _pickPokemon(i),
														child: ClipRRect(
															borderRadius: BorderRadius.circular(10),
															child: Image.network(
																p.imageUrl,
																width: 64,
																height: 64,
																fit: BoxFit.cover,
																errorBuilder: (context, error, stack) => Container(
																	width: 64,
																	height: 64,
																	color: Colors.black12,
																	alignment: Alignment.center,
																	child: const Icon(Icons.error, color: Colors.redAccent),
																),
															),
														),
													);
												} else {
													return GestureDetector(
														onTap: () => _pickPokemon(i),
														child: Container(
															width: 64,
															height: 64,
															decoration: BoxDecoration(
																borderRadius: BorderRadius.circular(10),
																border: Border.all(color: Colors.black26),
																color: Colors.white,
															),
															child: const Icon(Icons.add, color: Colors.black38),
														),
													);
												}
							}),
						),
					],
				),
			),
			bottomNavigationBar: SafeArea(
				child: Padding(
					padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
					child: Row(
						children: [
							Expanded(
								child: OutlinedButton(
									onPressed: () => Navigator.pop(context),
									child: const Text('Cancelar'),
								),
							),
							const SizedBox(width: 12),
							Expanded(
								child: ElevatedButton(
									onPressed: _saving ? null : _save,
									child: Text(isEdit ? 'Guardar cambios' : 'Crear equipo'),
								),
							),
						],
					),
				),
			),
		);
	}
}

