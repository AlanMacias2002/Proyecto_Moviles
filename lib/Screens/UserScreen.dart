import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final user = FirebaseAuth.instance.currentUser;
  File? _localImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _localImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al cerrar sesión: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage, // tap avatar to change
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _localImage != null
                    ? FileImage(_localImage!)
                    : user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : const AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              user?.displayName ?? 'No username',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              user?.email ?? 'No email',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al cerrar sesión: $e')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(160, 44)),
            ),
          ],
        ),
      ),
    );
  }
}
