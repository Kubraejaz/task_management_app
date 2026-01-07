class TaskModel {
  final String? id; // ✅ nullable (Supabase auto generates)
  final String title;
  final String description;
  final DateTime? createdAt; // ✅ nullable
  final DateTime dueDate;
  final bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    this.createdAt,
    required this.dueDate,
    required this.isCompleted,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id']?.toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      dueDate: DateTime.parse(map['due_date']),
      isCompleted: map['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // ❌ DO NOT send id
      'title': title,
      'description': description,
      // ❌ DO NOT send created_at (Supabase handles it)
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
