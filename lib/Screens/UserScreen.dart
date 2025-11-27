import 'package:flutter/material.dart';
import 'package:proyecto_moviles/Screens/UserScreen_fixed.dart';

// Simple wrapper that forwards to the fixed user profile screen
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) => const UserProfileScreen();
}
