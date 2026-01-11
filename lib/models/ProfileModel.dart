class ProfileModel {
  final String id;
  final String email;
  final String role;

  ProfileModel({
    required this.id,
    required this.email,
    required this.role,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      email: map['email'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
    };
  }
}