import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

class ARScreen extends StatefulWidget {
  final Map<String, dynamic> pokemon;

  const ARScreen({super.key, required this.pokemon});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ARKitController arkitController;
  ARKitNode? _pokemonNode;
  Timer? _animationTimer;
  List<String> _frames = [];
  int _currentFrameIndex = 0;
  final String _nodeName = "pokemonNode"; // Nombre único para el nodo

  @override
  void dispose() {
    _animationTimer?.cancel();
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR - ${widget.pokemon['name']}")),
      body: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
        enableTapRecognizer: true,
        showFeaturePoints: true,
        planeDetection: ARPlaneDetection.horizontal,
      ),
    );
  }

  Future<void> onARKitViewCreated(ARKitController controller) async {
    arkitController = controller;

    // 1. URL del Pokémon (Showdown son GIFs)
    var spriteUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/${widget.pokemon['id']}.gif';

    // 2. Procesar el GIF: Descargar y dividir en frames
    await _downloadAndSplitGif(spriteUrl);

    if (_frames.isEmpty) {
      print("⚠ No se pudieron obtener frames");
      return;
    }

    // 3. Crear el material inicial con el primer frame
    // Use a file:// URI for local temporary files so ARKit loads them correctly
    final initialImageUri = Uri.file(_frames[0]).toString();
    final material = ARKitMaterial(
      diffuse: ARKitMaterialProperty.image(initialImageUri),
      doubleSided: true,
      transparencyMode: ARKitTransparencyMode.aOne, // Usar alpha channel
    );

    // 4. Crear el plano y el nodo
    final plane = ARKitPlane(width: 0.25, height: 0.25, materials: [material]);

    final node = ARKitNode(
      name: _nodeName, // IMPORTANTE: Asignar nombre para actualizarlo después
      geometry: plane,
      position: Vector3(0, 0, -0.5),
    );

    // Keep a reference so we can move it later on tap
    _pokemonNode = node;
    arkitController.add(node);

    // Handle taps on the AR scene: move the pokemon node to the tapped world position
    arkitController.onARTap = (List<ARKitTestResult> results) {
      if (results.isEmpty) return;
      // Prefer existing plane hit, otherwise use first result
      ARKitTestResult? point;
      try {
        point = results.firstWhere(
          (r) => r.type == ARKitHitTestResultType.existingPlaneUsingExtent,
        );
      } catch (_) {
        point = results.first;
      }

      final worldTransform = point.worldTransform;
      final column = worldTransform.getColumn(3);
      final newPos = Vector3(column.x, column.y, column.z);
      if (_pokemonNode != null) {
        _pokemonNode!.position = newPos;
      }
    };

    // 5. Iniciar la animación
    _startAnimation();
  }

  void _startAnimation() {
    // Velocidad: 100ms es aprox 10fps (ajusta según necesites más velocidad)
    const duration = Duration(milliseconds: 100);

    _animationTimer = Timer.periodic(duration, (timer) {
      if (_frames.isEmpty) return;

      setState(() {
        _currentFrameIndex = (_currentFrameIndex + 1) % _frames.length;
      });

      // Actualizamos solo el material del nodo existente
      // Build a file URI for the current frame so ARKit can read the local image
      final currentImageUri = Uri.file(_frames[_currentFrameIndex]).toString();
      final newMaterial = ARKitMaterial(
        diffuse: ARKitMaterialProperty.image(currentImageUri),
        doubleSided: true,
        transparencyMode: ARKitTransparencyMode.aOne,
      );

      // Enviamos la actualización a ARKit
      arkitController.update(_nodeName, materials: [newMaterial]);
    });
  }

  Future<void> _downloadAndSplitGif(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return;

      // Use Flutter's image codec to decode GIF frames (works on iOS)
      final codec = await ui.instantiateImageCodec(response.bodyBytes);
      final frameCount = codec.frameCount;

      final directory = await getTemporaryDirectory();
      final List<String> tempPaths = [];

      for (int i = 0; i < frameCount; i++) {
        final frameInfo = await codec.getNextFrame();
        final ui.Image frameImage = frameInfo.image;

        final byteData = await frameImage.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData == null) continue;

        final pngBytes = byteData.buffer.asUint8List();
        final file = File(
          '${directory.path}/poke_${widget.pokemon['id']}_frame_$i.png',
        );
        await file.writeAsBytes(pngBytes);
        tempPaths.add(file.path);
      }

      setState(() {
        _frames = tempPaths;
      });
    } catch (e) {
      print("Error procesando GIF: $e");
    }
  }
}
