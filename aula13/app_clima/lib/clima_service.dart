// lib/clima_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ClimaService {
  // !! SUBSTITUA PELA SUA CHAVE !!
  // !! SUBSTITUA PELA SUA CHAVE !!
  // !! SUBSTITUA PELA SUA CHAVE !!
  // !! SUBSTITUA PELA SUA CHAVE !!
  // !! SUBSTITUA PELA SUA CHAVE !!
  final String _apiKey = '?????';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> buscarClima(
      double latitude, double longitude) async {
    // Monta a URL da API
    final url =
        '$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric&lang=pt_br';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Se a resposta for OK (200), decodifica o JSON
      final data = jsonDecode(response.body);

      // Exercício 4: Retorna os dados pedidos
      return {
        'temp': data['main']['temp'],
        'humidity': data['main']['humidity'],
        'speed': data['wind']['speed'],
      };
    } else {
      // Se der erro
      throw Exception('Falha ao carregar dados do clima.');
    }
  }
}
