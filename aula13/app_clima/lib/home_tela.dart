// lib/home_tela.dart

import 'package:flutter/material.dart';
import 'localizacao_service.dart';
import 'clima_service.dart';

class HomeTela extends StatefulWidget {
  const HomeTela({super.key});

  @override
  _HomeTelaState createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  // Instâncias das classes de serviço
  final Localizacao _localizacao = Localizacao();
  final ClimaService _climaService = ClimaService();

  // Variáveis de estado
  bool _isLoading = true;
  String _mensagem = 'Buscando localização...';
  Map<String, dynamic>? _dadosClima;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
      _mensagem = 'Buscando localização...';
      _dadosClima = null; // Limpa dados antigos
    });

    try {
      // Exercício 2: Chama o método
      await _localizacao.pegaLocalizacaoAtual();

      setState(() {
        _mensagem = 'Buscando dados do clima...';
      });

      // Exercício 4: Chama o serviço de clima
      if (_localizacao.latitude != null && _localizacao.longitude != null) {
        final clima = await _climaService.buscarClima(
          _localizacao.latitude!,
          _localizacao.longitude!,
        );
        setState(() {
          _dadosClima = clima;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Trata erros (permissão negada, etc.)
      setState(() {
        _mensagem = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsão do Tempo'),
      ),
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(_mensagem, style: const TextStyle(fontSize: 16)),
                ],
              )
            : _buildInfoClima(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _carregarDados,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildInfoClima() {
    // Se deu erro, _dadosClima será nulo
    if (_dadosClima == null) {
      return Text(
        'Erro: $_mensagem',
        style: const TextStyle(color: Colors.red, fontSize: 18),
        textAlign: TextAlign.center,
      );
    }

    // Se deu tudo certo
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercício 3: Mostra latitude e longitude
          Text(
            'Sua Localização:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            'Latitude: ${_localizacao.latitude ?? 'N/A'}',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Longitude: ${_localizacao.longitude ?? 'N/A'}',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),

          // Exercício 4: Mostra dados do clima
          Text(
            'Clima Atual:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            'Temperatura: ${_dadosClima!['temp']} °C',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Umidade: ${_dadosClima!['humidity']} %',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Vento: ${_dadosClima!['speed']} m/s',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
