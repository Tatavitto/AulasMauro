// lib/home_tela.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas_sqlite/add_task_tela.dart';
import 'package:lista_tarefas_sqlite/database_helper.dart';
import 'package:lista_tarefas_sqlite/task_model.dart';

class HomeTela extends StatefulWidget {
  const HomeTela({super.key});

  @override
  _HomeTelaState createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  final dbHelper = DatabaseHelper();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  late Future<List<Task>> _taskList;
  String? _filterDate; // Armazena a data do filtro

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  // Atualiza a lista de tarefas (seja todas ou filtrada)
  void _updateTaskList() {
    setState(() {
      if (_filterDate == null) {
        _taskList = dbHelper.getTasks(); // Requisito: Visualizar todas
      } else {
        _taskList = dbHelper
            .getTasksByDate(_filterDate!); // Requisito: Visualizar por data
      }
    });
  }

  // Requisito: Visualizar tarefa por data (Picker)
  _pickFilterDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _filterDate = _dateFormatter.format(date);
      });
      _updateTaskList();
    }
  }

  // Navega para a tela de adicionar/editar
  _navigateToAddTaskScreen([Task? task]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskTela(
          task: task,
          onTaskAddedOrUpdated: _updateTaskList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_filterDate == null
            ? 'Lista de Tarefas'
            : 'Tarefas de $_filterDate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickFilterDate,
          ),
          if (_filterDate != null)
            IconButton(
              icon: const Icon(Icons.clear), // Botão para limpar o filtro
              onPressed: () {
                setState(() {
                  _filterDate = null;
                });
                _updateTaskList();
              },
            ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _taskList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa encontrada.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              return _buildTaskTile(task);
            },
          );
        },
      ),
      // Requisito: Criar tarefa (Botão)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTaskScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget para cada item da lista
  Widget _buildTaskTile(Task task) {
    return ListTile(
      // Requisito: Marcar tarefa como feita
      leading: Checkbox(
        value: task.isDone,
        onChanged: (bool? value) async {
          if (value != null) {
            final updatedTask = task.copyWith(isDone: value);
            await dbHelper.updateTask(updatedTask);
            _updateTaskList();
          }
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(task.date),
      // Requisito: Alterar tarefa
      onTap: () => _navigateToAddTaskScreen(task),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () async {
          await dbHelper.deleteTask(task.id!);
          _updateTaskList();
        },
      ),
    );
  }
}
