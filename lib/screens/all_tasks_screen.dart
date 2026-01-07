import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await TaskService.getAllTasks();
    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteTask(String taskId) async {
    await TaskService.deleteTask(taskId);
    await _loadTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_tasks.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No tasks found',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('All Tasks')),
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                title: Text(task.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.description),
                    const SizedBox(height: 4),
                    Text(
                      'End: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: task.id == null
                      ? null
                      : () => _deleteTask(task.id!),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
