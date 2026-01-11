import 'package:flutter/material.dart';
import 'package:task_app/models/ProfileModel.dart';
import 'package:task_app/screens/AdminDashboard.dart';
import 'package:task_app/screens/StudentDashboard.dart';
import '../services/task_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ProfileModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final data = await TaskService.getProfiles();
    setState(() {
      _users = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final admins = _users.where((u) => u.role == 'admin').toList();
    final students = _users.where((u) => u.role == 'student').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 🔴 ADMIN SECTION
          _sectionHeader(
            title: 'Admins',
            icon: Icons.admin_panel_settings,
            color: Colors.red,
          ),
          const SizedBox(height: 8),
          admins.isEmpty
              ? _emptyText('No admin users')
              : Column(
                  children: admins
                      .map((user) => _userCard(
                            user: user,
                            color: Colors.red,
                            onView: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AdminDashboard(user: user),
                                ),
                              );
                            },
                          ))
                      .toList(),
                ),

          const SizedBox(height: 32),

          /// 🔵 STUDENT SECTION
          _sectionHeader(
            title: 'Students',
            icon: Icons.school,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          students.isEmpty
              ? _emptyText('No student users')
              : Column(
                  children: students
                      .map((user) => _userCard(
                            user: user,
                            color: Colors.blue,
                            onView: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      StudentDashboard(user: user),
                                ),
                              );
                            },
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  /// ===== UI COMPONENTS =====

  Widget _sectionHeader({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _userCard({
    required ProfileModel user,
    required Color color,
    required VoidCallback onView,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            Icons.person,
            color: color,
          ),
        ),
        title: Text(
          user.email,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Role: ${user.role}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: onView,
          child: const Text('View'),
        ),
      ),
    );
  }

  Widget _emptyText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
