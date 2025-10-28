import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instancia = DatabaseHelper._interno();
  factory DatabaseHelper() => _instancia;
  DatabaseHelper._interno();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'calculadora.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela para salvar o estado atual
    await db.execute('''
      CREATE TABLE dados(
        id INTEGER PRIMARY KEY,
        tela TEXT,
        memoria REAL
      )
    ''');

    // Tabela para salvar o histórico de operações
    await db.execute('''
      CREATE TABLE operacoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operacao TEXT
      )
    ''');
  }

  // Salva (ou atualiza) o estado da tela e memória
  Future<void> salvarEstado(String tela, double memoria) async {
    final db = await database;
    await db.insert(
      'dados',
      {'id': 1, 'tela': tela, 'memoria': memoria},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Carrega o último estado salvo
  Future<Map<String, dynamic>> carregarEstado() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dados',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      // Retorna um estado padrão se o banco estiver vazio
      return {'tela': '0', 'memoria': 0.0};
    }
  }

  // Insere uma nova operação no histórico
  Future<void> inserirOperacao(String operacao) async {
    final db = await database;
    await db.insert(
      'operacoes',
      {'operacao': operacao},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Pega todo o histórico de operações
  Future<List<Map<String, dynamic>>> getHistoricoOperacoes() async {
    final db = await database;
    return await db.query('operacoes', orderBy: 'id DESC');
  }
}
