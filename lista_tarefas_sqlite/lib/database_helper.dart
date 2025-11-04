// lib/database_helper.dart

import 'package:lista_tarefas_sqlite/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton (instância única)
  static final DatabaseHelper _instancia = DatabaseHelper._interno();
  factory DatabaseHelper() => _instancia;
  DatabaseHelper._interno();

  static Future<Database>? _databaseFuture;

  Future<Database> get database async {
    if (_databaseFuture != null) {
      return _databaseFuture!;
    }
    _databaseFuture = _initDB();
    return _databaseFuture!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'tarefas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tarefas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        isDone INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // Requisito: Criar tarefa
  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tarefas',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Requisitos: Marcar como feita E Alterar tarefa
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tarefas',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // (Extra, mas essencial) Deletar tarefa
  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Requisito: Visualizar todas as tarefas
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('tarefas', orderBy: 'date ASC');

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Requisito: Visualizar tarefa por data
  Future<List<Task>> getTasksByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tarefas',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'isDone ASC',
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }
}
