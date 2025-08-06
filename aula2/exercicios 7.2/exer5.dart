import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> buscaCotacaoEm3Julho2025() async {
  var url = Uri.https(
    'olinda.bcb.gov.br',
    '/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)',
    {
      '@dataCotacao': '\'07-03-2025\'',
      '\$top': '100',
      '\$format': 'json',
      '\$select': 'cotacaoCompra',
    },
  );

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      var cotacao = jsonBody['value'][0]['cotacaoCompra'];
      print('Cotação do dólar em 03/07/2025: R\$ $cotacao');
    } else {
      print('Erro ao acessar a API. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro durante a requisição: $e');
  }
}

void main() {
  buscaCotacaoEm3Julho2025();
}
