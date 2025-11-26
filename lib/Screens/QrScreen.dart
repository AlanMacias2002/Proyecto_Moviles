import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:proyecto_moviles/Services/party_repository.dart';
import 'package:proyecto_moviles/Screens/new_edit_partyScreen.dart';

class QrScreen extends StatefulWidget {
	const QrScreen({super.key});

	@override
	State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final _scannerController = MobileScannerController(formats: [BarcodeFormat.qrCode]);
  final _repo = PartyRepository();
  bool _scanning = false;
  bool _importing = false;
  String? _error;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _toggleScan() {
    setState(() {
      _error = null;
      _scanning = !_scanning;
    });
    if (_scanning) {
      _scannerController.start();
    } else {
      _scannerController.stop();
    }
  }

	Widget _buildPreviewArea() {
		if (_error != null) {
			return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
		}
		if (_scanning) {
			return ClipRRect(
				borderRadius: BorderRadius.circular(16),
				child: Stack(
					fit: StackFit.expand,
					children: [
						MobileScanner(
							controller: _scannerController,
							onDetect: (capture) async {
								if (_importing) return; // evitar múltiples lecturas
								final barcodes = capture.barcodes;
								if (barcodes.isEmpty) return;
								final raw = barcodes.first.rawValue;
								if (raw == null || raw.isEmpty) return;
								setState(() => _importing = true);
								try {
									// Obtener datos y luego importar (una sola lectura de shared_parties)
									final partyFromShare = await _repo.fetchSharedParty(raw);
									final newId = await _repo.createParty(partyFromShare);
									if (!mounted) return;
									_scannerController.stop();
									_scanning = false;
									ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Equipo importado')));
									Navigator.of(context).pushReplacement(
										MaterialPageRoute(
											builder: (_) => NewEditPartyScreen(party: partyFromShare, partyId: newId),
										),
									);
								} catch (e) {
									if (mounted) {
										ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
									}
									setState(() => _importing = false);
								}
							},
						),
						const _ScannerOverlay(),
						if (_importing)
							Container(
								color: Colors.black45,
								child: const Center(child: CircularProgressIndicator()),
							),
					],
				),
			);
		}
		return Container(
			width: double.infinity,
			decoration: BoxDecoration(
				color: Colors.black12,
				borderRadius: BorderRadius.circular(16),
				border: Border.all(color: Colors.black26),
			),
			child: const Center(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Icon(Icons.qr_code_scanner, size: 64, color: Colors.black45),
						SizedBox(height: 12),
						Text('Pulsa "Escanear" para activar la cámara',
								style: TextStyle(color: Colors.black54), textAlign: TextAlign.center),
					],
				),
			),
		);
	}

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
							const SnackBar(content: Text('Apunta la cámara al código QR del equipo.')),
						),
					),
				],
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					children: [
										Expanded(child: _buildPreviewArea()),
						const SizedBox(height: 16),
						Row(
							children: [
								Expanded(
									child: ElevatedButton.icon(
														onPressed: _importing ? null : _toggleScan,
														icon: Icon(_scanning ? Icons.stop : Icons.camera_alt_outlined),
														label: Text(_scanning ? 'Detener' : 'Escanear'),
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

/// Overlay con un rectángulo de enfoque para el escaneo del QR.
class _ScannerOverlay extends StatelessWidget {
	const _ScannerOverlay();

	@override
	Widget build(BuildContext context) {
		return IgnorePointer(
			child: LayoutBuilder(
				builder: (context, constraints) {
					final size = constraints.biggest;
					final boxSide = (size.shortestSide * 0.6).clamp(220, 300).toDouble();
					final rect = Rect.fromCenter(
						center: size.center(Offset.zero),
						width: boxSide,
						height: boxSide,
					);
					return CustomPaint(
						painter: _ScannerOverlayPainter(rect: rect),
					);
				},
			),
		);
	}
}

class _ScannerOverlayPainter extends CustomPainter {
	final Rect rect;
	_ScannerOverlayPainter({required this.rect});

	@override
	void paint(Canvas canvas, Size size) {
		// Fondo oscurecido
		final overlayPaint = Paint()..color = Colors.black.withOpacity(0.35);
		final clearPaint = Paint()..blendMode = BlendMode.clear;

		// Capa para aplicar efecto "agujero"
		canvas.saveLayer(Offset.zero & size, Paint());
		canvas.drawRect(Offset.zero & size, overlayPaint);
		canvas.drawRect(rect, clearPaint);

		// Bordes y esquinas del rectángulo de enfoque
		final borderPaint = Paint()
			..color = Colors.white
			..style = PaintingStyle.stroke
			..strokeWidth = 3;
		canvas.drawRect(rect, borderPaint);

		// Esquinas resaltadas
		final cornerLength = rect.width * 0.12;
		final cornerPaint = Paint()
			..color = Colors.lightBlueAccent
			..strokeWidth = 5
			..style = PaintingStyle.stroke
			..strokeCap = StrokeCap.round;

		void drawCorner(double x, double y, bool top, bool left) {
			final dx = left ? 1 : -1;
			final dy = top ? 1 : -1;
			final p1 = Offset(x, y);
			final p2 = Offset(x + cornerLength * dx, y);
			final p3 = Offset(x, y + cornerLength * dy);
			canvas.drawLine(p1, p2, cornerPaint);
			canvas.drawLine(p1, p3, cornerPaint);
		}

		drawCorner(rect.left, rect.top, true, true);
		drawCorner(rect.right, rect.top, true, false);
		drawCorner(rect.left, rect.bottom, false, true);
		drawCorner(rect.right, rect.bottom, false, false);

		canvas.restore();
	}

	@override
	bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) => oldDelegate.rect != rect;
}

