import 'package:flutter/material.dart';
import 'calculadora_tela.dart';

// Inicializa o binding antes de carregar o estado
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora SQLite',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: const CalculadoraTela(),
    );
  }
}
