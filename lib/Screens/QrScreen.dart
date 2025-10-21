import 'package:flutter/material.dart';

class QrScreen extends StatelessWidget {
	const QrScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Escanear QR'),
				actions: [
					IconButton(
						tooltip: 'Ayuda',
						icon: const Icon(Icons.help_outline),
						onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
							const SnackBar(content: Text('Funcionalidad QR ayuda')),
						),
					),
				],
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					children: [
						// Área simulada de cámara/visor
						Expanded(
							child: Container(
								width: double.infinity,
								decoration: BoxDecoration(
									color: Colors.black12,
									borderRadius: BorderRadius.circular(16),
									border: Border.all(color: Colors.black26),
								),
								child: Center(
									child: Column(
										mainAxisSize: MainAxisSize.min,
										children: const [
											Icon(Icons.qr_code_scanner, size: 64, color: Colors.black45),
											SizedBox(height: 12),
											Text('Vista previa del escáner (placeholder)',
													style: TextStyle(color: Colors.black54)),
										],
									),
								),
							),
						),
						const SizedBox(height: 16),
						Row(
							children: [
								Expanded(
									child: ElevatedButton.icon(
										onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
											const SnackBar(content: Text('Funcionalidad abrir cámara / escanear')),
										),
										icon: const Icon(Icons.camera_alt_outlined),
										label: const Text('Escanear'),
									),
								),
							],
						),
						const SizedBox(height: 8),
						TextButton(
							onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
								const SnackBar(content: Text('Funcionalidad ingresar código manual')),
							),
							child: const Text('Ingresar código manual'),
						),
					],
				),
			),
		);
	}
}

