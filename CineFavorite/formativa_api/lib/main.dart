import 'package:flutter/material.dart';
import 'views/perfil_view.dart';

void main() {
  runApp(const CineFavoriteApp());
}

class CineFavoriteApp extends StatelessWidget {
  const CineFavoriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineFavorite',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const PerfilView(),
    );
  }
}