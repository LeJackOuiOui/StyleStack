import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io'; // Para trabajar con archivos del movil
import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context){
    // Escuchar el proveedor
    final profileProvider = context.watch<ProfileProvider>();
    final image = profileProvider.imageFile;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil SENA beats')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // AVATAR CIRCULAR
            GestureDetector(
              onTap: () => profileProvider.takePhoto(), // Tocar para tomar foto
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.deepPurple[900],
                    // Si hay foto, la mostramos. Si no, un icono gris.
                    backgroundImage: image != null ? FileImage(image) : null, 
                    child: image == null 
                        ? const Icon(Icons.person, size: 70, color: Colors.white70) 
                        : null,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepPurple, width: 2)
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Aprendiz ADSO', 
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text('Pixel User - SENA beats', style: TextStyle(color: Colors.grey)),
            const Spacer(),
            const Text('Hecho con ❤️ en Linux Mint', style: TextStyle(color: Colors.white12)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}