import 'package:flutter/material.dart';

class ShareQrScreen extends StatelessWidget {
	const ShareQrScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Compartir QR')),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						const SizedBox(height: 12),
						// Marco del QR de ejemplo
						Expanded(
							child: Center(
								child: Container(
									width: 260,
									height: 260,
									decoration: BoxDecoration(
										color: Colors.white,
										borderRadius: BorderRadius.circular(16),
										border: Border.all(color: Colors.black26),
										boxShadow: const [
											BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
										],
									),
									child: const Center(
										child: Icon(Icons.qr_code_2, size: 180, color: Colors.black87),
									),
								),
							),
						),
						const SizedBox(height: 16),
						const Text(
							'QR de ejemplo\n(Aquí se mostrará el QR real del equipo para compartir)',
							textAlign: TextAlign.center,
							style: TextStyle(color: Colors.black54),
						),
						const SizedBox(height: 16),
						Row(
							children: [
								Expanded(
									child: OutlinedButton.icon(
										onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
											const SnackBar(content: Text('Función copiar QR (pendiente)')),
										),
										icon: const Icon(Icons.copy),
										label: const Text('Copiar'),
									),
								),
								const SizedBox(width: 12),
								Expanded(
									child: ElevatedButton.icon(
										onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
											const SnackBar(content: Text('Función compartir QR (pendiente)')),
										),
										icon: const Icon(Icons.share),
										label: const Text('Compartir'),
									),
								),
							],
						),
					],
				),
			),
		);
	}
}

