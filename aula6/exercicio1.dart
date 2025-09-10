import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    home: JogoJokenpo(),
    debugShowCheckedModeBanner: false,
  ));
}

class JogoJokenpo extends StatefulWidget {
  const JogoJokenpo({super.key});

  @override
  State<JogoJokenpo> createState() => _JogoJokenpoState();
}

class _JogoJokenpoState extends State<JogoJokenpo> {
  final List<String> _imagens = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg'
  ];


  String _imagemAtual = 'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg';

  void _escolherOpcao() {
    int numeroSorteado = Random().nextInt(3);
    setState(() {
      _imagemAtual = _imagens[numeroSorteado];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedra, Papel e Tesoura'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'A escolha do App é:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Image.network(
                _imagemAtual,
                height: 200,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _escolherOpcao,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Escolher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}