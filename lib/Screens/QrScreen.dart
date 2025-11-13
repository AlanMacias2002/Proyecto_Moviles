import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class QrScreen extends StatefulWidget {
	const QrScreen({super.key});

	@override
	State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
	CameraController? _controller;
	Future<void>? _initializeControllerFuture;
	bool _cameraActive = false;
	bool _initializing = false;
	String? _error;

	@override
	void dispose() {
		_controller?.dispose();
		super.dispose();
	}

	Future<void> _startCamera() async {
		if (_initializing) return;
		setState(() {
			_initializing = true;
			_error = null;
		});
		final status = await Permission.camera.request();
		if (!status.isGranted) {
			setState(() {
				_error = 'Permiso de cámara denegado';
				_initializing = false;
			});
			return;
		}
		try {
			final cameras = await availableCameras();
			if (cameras.isEmpty) {
				setState(() {
					_error = 'No se encontró cámara';
					_initializing = false;
				});
				return;
			}
			_controller = CameraController(
				cameras.first,
				ResolutionPreset.medium,
				enableAudio: false,
			);
			_initializeControllerFuture = _controller!.initialize();
			await _initializeControllerFuture;
			if (!mounted) return;
			setState(() {
				_cameraActive = true;
				_initializing = false;
			});
		} catch (e) {
			if (!mounted) return;
			setState(() {
				_error = 'Error iniciando cámara: $e';
				_initializing = false;
			});
		}
	}

	Widget _buildPreviewArea() {
		if (_error != null) {
			return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
		}
		if (_cameraActive && _controller != null) {
			return FutureBuilder<void>(
				future: _initializeControllerFuture,
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.done) {
						return ClipRRect(
							borderRadius: BorderRadius.circular(16),
							child: Stack(
								fit: StackFit.expand,
								children: [
									CameraPreview(_controller!),
									const _ScannerOverlay(),
								],
							),
						);
					} else {
						return const Center(child: CircularProgressIndicator());
					}
				},
			);
		}
		// Placeholder inicial antes de activar cámara
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
								style: TextStyle(color: Colors.black54),
								textAlign: TextAlign.center),
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
										onPressed: _initializing ? null : _startCamera,
										icon: const Icon(Icons.camera_alt_outlined),
										label: Text(_cameraActive ? 'Reiniciar cámara' : 'Escanear'),
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

