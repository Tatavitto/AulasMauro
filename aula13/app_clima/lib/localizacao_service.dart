// lib/localizacao_service.dart

import 'package:geolocator/geolocator.dart';

// Exercício 1: Crie a classe Localização
class Localizacao {
  // Atributos latitude e longitude
  double? latitude;
  double? longitude;

  // Exercício 2: Crie o método pegaLocalizacaoAtual()
  Future<void> pegaLocalizacaoAtual() async {
    // 1. Checa se o serviço de localização está habilitado
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      throw Exception('Serviço de localização desabilitado.');
    }

    // 2. Checa as permissões
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente.');
    }

    // 3. Pega a posição e ajusta os atributos
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude;
    longitude = position.longitude;
  }
}
