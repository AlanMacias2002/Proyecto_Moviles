import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:proyecto_moviles/Services/party_repository.dart';

class ShareQrScreen extends StatefulWidget {
	const ShareQrScreen({super.key, required this.partyId});
	final String partyId;

	@override
	State<ShareQrScreen> createState() => _ShareQrScreenState();
}

class _ShareQrScreenState extends State<ShareQrScreen> {
	final _repo = PartyRepository();
	Future<String>? _futureShareId;

	@override
	void initState() {
		super.initState();
		_futureShareId = _repo.shareParty(widget.partyId);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Compartir equipo')),
			body: FutureBuilder<String>(
				future: _futureShareId,
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return const Center(child: CircularProgressIndicator());
					}
					if (snapshot.hasError) {
						return Center(child: Text('Error al generar QR: ${snapshot.error}'));
					}
					final shareId = snapshot.data!;
					return Padding(
						padding: const EdgeInsets.all(16.0),
						child: Column(
							children: [
								Expanded(
									child: Center(
										child: Container(
											padding: const EdgeInsets.all(12),
											decoration: BoxDecoration(
												color: Colors.white,
												borderRadius: BorderRadius.circular(16),
												border: Border.all(color: Colors.black26),
												boxShadow: const [
													BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
												],
											),
											child: QrImageView(
												data: shareId,
												version: QrVersions.auto,
												size: 240,
												gapless: true,
												eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
												dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.black),
											),
										),
									),
								),
								const SizedBox(height: 8),
								SelectableText('ID: $shareId', style: const TextStyle(fontSize: 14, color: Colors.black54)),
								const SizedBox(height: 16),
								Row(
									children: [
										Expanded(
											child: OutlinedButton.icon(
												onPressed: () async {
													  await Clipboard.setData(ClipboardData(text: shareId));
													if (!mounted) return;
													ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID copiado')));
												},
												icon: const Icon(Icons.copy),
												label: const Text('Copiar ID'),
											),
										),
										const SizedBox(width: 12),
										Expanded(
											child: ElevatedButton.icon(
												onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compartir pendiente'))),
												icon: const Icon(Icons.share),
												label: const Text('Compartir'),
											),
										),
									],
								),
								const SizedBox(height: 12),
								const Text('Escanea este código en otro dispositivo para importar el equipo.', textAlign: TextAlign.center),
							],
						),
					);
				},
			),
		);
	}
}

