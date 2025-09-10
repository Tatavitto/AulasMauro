import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    home: JogoJokenpoAleatorioControlado(),
    debugShowCheckedModeBanner: false,
  ));
}

class JogoJokenpoAleatorioControlado extends StatefulWidget {
  const JogoJokenpoAleatorioControlado({super.key});

  @override
  State<JogoJokenpoAleatorioControlado> createState() =>
      _JogoJokenpoAleatorioControladoState();
}

class _JogoJokenpoAleatorioControladoState
    extends State<JogoJokenpoAleatorioControlado> {
  final Map<String, String> _imagens = {
    'padrao': 'https://cdn-icons-png.flaticon.com/512/1011/1011112.png',
    'pedra':
        'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
    'papel': 'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
    'tesoura':
        'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg'
  };

  String _imagemApp = 'padrao';
  String _mensagem = 'Escolha uma opção abaixo!';
  int _contadorDeJogadas = 0;
  int _rodadaGanhadoraDoCiclo = 0;

  @override
  void initState() {
    super.initState();
    _definirProximaRodadaGanhadora();
  }

  void _definirProximaRodadaGanhadora() {
    setState(() {
      _rodadaGanhadoraDoCiclo = Random().nextInt(5) + 1;
    });
  }

  void _jogar(String escolhaUsuario) {
    setState(() {
      _contadorDeJogadas++;
      int jogadaAtualNoCiclo = ((_contadorDeJogadas - 1) % 5) + 1;

      String escolhaApp;
      var random = Random();

      if (jogadaAtualNoCiclo == _rodadaGanhadoraDoCiclo) {
        if (escolhaUsuario == 'pedra') {
          escolhaApp = 'tesoura';
        } else if (escolhaUsuario == 'papel') {
          escolhaApp = 'pedra';
        } else {
          escolhaApp = 'papel';
        }
      } else {
        if (random.nextBool()) {
          escolhaApp = escolhaUsuario;
        } else {
          if (escolhaUsuario == 'pedra') {
            escolhaApp = 'papel';
          } else if (escolhaUsuario == 'papel') {
            escolhaApp = 'tesoura';
          } else {
            escolhaApp = 'pedra';
          }
        }
      }

      _imagemApp = escolhaApp;

      if ((escolhaUsuario == 'pedra' && escolhaApp == 'tesoura') ||
          (escolhaUsuario == 'tesoura' && escolhaApp == 'papel') ||
          (escolhaUsuario == 'papel' && escolhaApp == 'pedra')) {
        _mensagem = 'Parabéns!!! Você ganhou! :)';
      } else if (escolhaApp == escolhaUsuario) {
        _mensagem = 'Empatamos! ;)';
      } else {
        _mensagem = 'A máquina ganhou! :(';
      }

      if (_contadorDeJogadas % 5 == 0) {
        _definirProximaRodadaGanhadora();
      }
    });
  }

  String _textoContador() {
    if (_contadorDeJogadas == 0) {
      return 'Boa sorte!';
    }
    int jogadaExibida = _contadorDeJogadas % 5;
    if (jogadaExibida == 0) {
      jogadaExibida = 5;
    }
    return 'Jogada $jogadaExibida de 5';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jokenpo "Quase" Aleatório'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Escolha do App',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Image.network(_imagens[_imagemApp]!, height: 120),
              const SizedBox(height: 30),
              Text(
                _mensagem,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 40),
              const Text('Sua escolha:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => _jogar('pedra'),
                    child: Image.network(_imagens['pedra']!, height: 80),
                  ),
                  GestureDetector(
                    onTap: () => _jogar('papel'),
                    child: Image.network(_imagens['papel']!, height: 80),
                  ),
                  GestureDetector(
                    onTap: () => _jogar('tesoura'),
                    child: Image.network(_imagens['tesoura']!, height: 80),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                _textoContador(),
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}