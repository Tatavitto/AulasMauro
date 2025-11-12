// lib/main.dart

import 'package:flutter/material.dart';
import 'home_tela.dart'; // Importa a nova tela

void main() {
  // Garante que o Flutter esteja inicializado
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Clima',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeTela(), // Define a HomeTela como inicial
    );
  }
}
