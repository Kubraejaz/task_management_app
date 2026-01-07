import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'all_tasks_screen.dart';
import 'create_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<TaskModel> _recentTasks = [];

  @override
  void initState() {
    super.initState();
    _loadRecentTasks();
  }

  Future<void> _loadRecentTasks() async {
    final tasks = await TaskService.getRecentTasks(); // ✅ static call
    setState(() {
      _recentTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Tasks '),
        centerTitle: true,
      ),
      body: _currentIndex == 0
          ? _buildHome()
          : _currentIndex == 1
              ? const AllTasksScreen()
              : const CreateTaskScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
        ],
      ),
    );
  }

  /// HOME SCREEN → Recent 5 Tasks
  Widget _buildHome() {
    if (_recentTasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks yet',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRecentTasks,
      child: ListView.builder(
        itemCount: _recentTasks.length,
        itemBuilder: (context, index) {
          final task = _recentTasks[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: Text(
                task.dueDate.toLocal().toString().split(' ')[0],
              ),
            ),
          );
        },
      ),
    );
  }
}
