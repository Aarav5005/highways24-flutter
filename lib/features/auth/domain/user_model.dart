class UserModel {
  final String id;
  final String phone;
  final String name;
  final String role;

  const UserModel({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
  });

  UserModel copyWith({
    String? id,
    String? phone,
    String? name,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }
}
