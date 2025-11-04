// lib/main.dart

import 'package:flutter/material.dart';
import 'package:lista_tarefas_sqlite/home_tela.dart';

// Inicializa o binding antes de carregar o banco
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas SQLite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeTela(),
    );
  }
}
