import 'dart:convert';
import 'package:http/http.dart' as http;

String formatarDataParaAPI(DateTime data) {
  return '${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}-${data.year}';
}

Future<void> buscaCotacaoRecente() async {
  DateTime hoje = DateTime.now();
  DateTime dataConsulta = hoje.subtract(Duration(days: 1));

  if (dataConsulta.weekday == DateTime.sunday) {
    dataConsulta = dataConsulta.subtract(Duration(days: 2));
  }

  String dataFormatada = formatarDataParaAPI(dataConsulta);

  var url = Uri.https(
    'olinda.bcb.gov.br',
    '/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)',
    {
      '@dataCotacao': '\'$dataFormatada\'',
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
      print(
        'Cotação do dólar em ${dataConsulta.day}/${dataConsulta.month}/${dataConsulta.year}: R\$ $cotacao',
      );
    } else {
      print('Erro ao acessar a API. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro durante a requisição: $e');
  }
}

void main() {
  buscaCotacaoRecente();
}
