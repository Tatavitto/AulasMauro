// lib/task_model.dart

class Task {
  final int? id;
  final String title;
  final String date; // Formato YYYY-MM-DD
  final bool isDone;

  Task({
    this.id,
    required this.title,
    required this.date,
    this.isDone = false,
  });

  // Converte um objeto Task em um Map (para o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'isDone': isDone ? 1 : 0, // SQLite usa 1 (true) e 0 (false)
    };
  }

  // Converte um Map (do banco de dados) em um objeto Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      isDone: map['isDone'] == 1,
    );
  }

  // Método 'copyWith' para facilitar a atualização de tarefas
  Task copyWith({
    int? id,
    String? title,
    String? date,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
    );
  }
}
