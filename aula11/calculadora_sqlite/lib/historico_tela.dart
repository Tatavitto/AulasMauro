import 'package:flutter/material.dart';
import 'database_helper.dart';

class HistoricoTela extends StatefulWidget {
  const HistoricoTela({super.key});

  @override
  _HistoricoTelaState createState() => _HistoricoTelaState();
}

class _HistoricoTelaState extends State<HistoricoTela> {
  final dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _historico;

  @override
  void initState() {
    super.initState();
    _historico = dbHelper.getHistoricoOperacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Operações'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historico,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma operação no histórico.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    snapshot.data![index]['operacao'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
