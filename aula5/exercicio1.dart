import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int? operador1;
  int? operador2;
  bool somaApertado = false;
  int resultado = 0;

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == "+") {
        somaApertado = true;
      } else if (valor == "=") {
        if (operador1 != null && operador2 != null) {
          resultado = operador1! + operador2!;
        }
      } else {
        int numero = int.parse(valor);
        if (!somaApertado) {
          operador1 = (operador1 ?? 0) * 10 + numero;
        } else {
          operador2 = (operador2 ?? 0) * 10 + numero;
        }
      }

      // Debug Console
      print("Operador 1: $operador1");
      print("Operador 2: $operador2");
      print("Soma apertado: $somaApertado");
      print("Resultado: $resultado");
      print("--------------------------");
    });
  }

  Widget _criarBotao(String texto) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _pressionarBotao(texto),
          child: Text(texto, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Calculadora Simples")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              _criarBotao("7"),
              _criarBotao("8"),
              _criarBotao("9")
            ]),
            Row(children: [
              _criarBotao("4"),
              _criarBotao("5"),
              _criarBotao("6")
            ]),
            Row(children: [
              _criarBotao("1"),
              _criarBotao("2"),
              _criarBotao("3")
            ]),
            Row(children: [
              _criarBotao("0"),
              _criarBotao("="),
              _criarBotao("+")
            ]),
          ],
        ),
      ),
    );
  }
}
