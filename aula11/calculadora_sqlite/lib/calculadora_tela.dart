import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'historico_tela.dart';

class CalculadoraTela extends StatefulWidget {
  const CalculadoraTela({super.key});

  @override
  _CalculadoraTelaState createState() => _CalculadoraTelaState();
}

class _CalculadoraTelaState extends State<CalculadoraTela> {
  final dbHelper = DatabaseHelper();
  String _textoVisor = '0';
  double _memoria = 0.0;

  // Variáveis para lógica de cálculo
  double _primeiroNumero = 0.0;
  String _operacaoPendente = '';
  bool _novaEntrada = true;

  @override
  void initState() {
    super.initState();
    _carregarEstado();
  }

  void _carregarEstado() async {
    final estado = await dbHelper.carregarEstado();
    setState(() {
      _textoVisor = estado['tela'];
      _memoria = estado['memoria'];
    });
  }

  void _salvarEstadoAtual() {
    dbHelper.salvarEstado(_textoVisor, _memoria);
  }

  void _pressionouBotao(String textoBotao) {
    setState(() {
      if ('0123456789.'.contains(textoBotao)) {
        // Lógica para números e ponto
        if (_novaEntrada) {
          _textoVisor = textoBotao == '.' ? '0.' : textoBotao;
          _novaEntrada = false;
        } else if (textoBotao == '.' && _textoVisor.contains('.')) {
          return; // Ignora segundo ponto
        } else {
          _textoVisor += textoBotao;
        }
      } else if ('+-*/'.contains(textoBotao)) {
        // Lógica para operações
        _primeiroNumero = double.parse(_textoVisor);
        _operacaoPendente = textoBotao;
        _novaEntrada = true;
      } else if (textoBotao == '=') {
        // Lógica para igual
        if (_operacaoPendente.isEmpty) return;

        double segundoNumero = double.parse(_textoVisor);
        double resultado = 0.0;

        if (_operacaoPendente == '+') {
          resultado = _primeiroNumero + segundoNumero;
        } else if (_operacaoPendente == '-') {
          resultado = _primeiroNumero - segundoNumero;
        } else if (_operacaoPendente == '*') {
          resultado = _primeiroNumero * segundoNumero;
        } else if (_operacaoPendente == '/') {
          if (segundoNumero == 0) {
            _textoVisor = 'Erro';
            return;
          }
          resultado = _primeiroNumero / segundoNumero;
        }

        String operacaoCompleta =
            '$_primeiroNumero $_operacaoPendente $segundoNumero = $resultado';
        dbHelper.inserirOperacao(operacaoCompleta); // Salva no histórico

        _textoVisor = resultado.toString();
        _operacaoPendente = '';
        _novaEntrada = true;
      } else if (textoBotao == 'C') {
        // Lógica para Limpar
        _textoVisor = '0';
        _primeiroNumero = 0.0;
        _operacaoPendente = '';
        _novaEntrada = true;
      } else if (textoBotao == 'MC') {
        // Lógica para Memória Limpar (MC)
        _memoria = 0.0;
      } else if (textoBotao == 'MR') {
        // Lógica para Memória Recuperar (MR)
        _textoVisor = _memoria.toString();
        _novaEntrada = true;
      } else if (textoBotao == 'M+') {
        // Lógica para Memória Adicionar (M+)
        _memoria += double.parse(_textoVisor);
      } else if (textoBotao == 'M-') {
        // Lógica para Memória Subtrair (M-)
        _memoria -= double.parse(_textoVisor);
      }
    });

    _salvarEstadoAtual(); // Salva o estado após qualquer operação
  }

  // --- UI ---
  Widget _buildButton(String texto,
      {int flex = 1, Color cor = Colors.black54}) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cor,
            padding: const EdgeInsets.all(24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _pressionouBotao(texto),
          child: Text(
            texto,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora SQLite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoricoTela()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Visor
          Expanded(
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Text(
                _textoVisor,
                style: const TextStyle(fontSize: 60, color: Colors.white),
                maxLines: 1,
              ),
            ),
          ),
          // Botões
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('MC', cor: Colors.deepOrange),
                    _buildButton('MR', cor: Colors.deepOrange),
                    _buildButton('M+', cor: Colors.deepOrange),
                    _buildButton('M-', cor: Colors.deepOrange),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('C', cor: Colors.grey[700]!),
                    _buildButton('/', cor: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('*', cor: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', cor: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', cor: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0', flex: 2),
                    _buildButton('.'),
                    _buildButton('=', cor: Colors.orange),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
