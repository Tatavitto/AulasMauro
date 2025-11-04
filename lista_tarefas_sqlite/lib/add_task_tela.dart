// lib/add_task_tela.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas_sqlite/database_helper.dart';
import 'package:lista_tarefas_sqlite/task_model.dart';

class AddTaskTela extends StatefulWidget {
  final Task? task; // Tarefa opcional para modo de edição
  final Function()? onTaskAddedOrUpdated; // Função de callback

  const AddTaskTela({super.key, this.task, this.onTaskAddedOrUpdated});

  @override
  _AddTaskTelaState createState() => _AddTaskTelaState();
}

class _AddTaskTelaState extends State<AddTaskTela> {
  final dbHelper = DatabaseHelper();
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _selectedDate = widget.task != null
        ? _dateFormatter.parse(widget.task!.date)
        : DateTime.now();
  }

  _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  _submit() async {
    if (_titleController.text.isEmpty) return;

    if (widget.task == null) {
      // Criar nova tarefa
      Task newTask = Task(
        title: _titleController.text,
        date: _dateFormatter.format(_selectedDate),
      );
      await dbHelper.insertTask(newTask);
    } else {
      // Alterar tarefa existente
      Task updatedTask = widget.task!.copyWith(
        title: _titleController.text,
        date: _dateFormatter.format(_selectedDate),
      );
      await dbHelper.updateTask(updatedTask);
    }

    // Chama o callback e fecha a tela
    widget.onTaskAddedOrUpdated?.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título da Tarefa'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Data: ${_dateFormatter.format(_selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Selecionar Data'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(widget.task == null ? 'Adicionar' : 'Salvar'),
            )
          ],
        ),
      ),
    );
  }
}
