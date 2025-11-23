import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ARScreen extends StatefulWidget {
  final Map<String, dynamic> pokemon;

  const ARScreen({super.key, required this.pokemon});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR - ${widget.pokemon['name']}")),
      body: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
        planeDetection: ARPlaneDetection.horizontal,
      ),
    );
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;

    // Nodo simple (una esfera azul) para probar
    final node = ARKitNode(
      geometry: ARKitSphere(
        radius: 0.1,
        materials: [
          ARKitMaterial(diffuse: ARKitMaterialProperty.color(Colors.blue)),
        ],
      ),
      position: Vector3(0, 0, -0.5),
    );

    arkitController.add(node);
  }
}
