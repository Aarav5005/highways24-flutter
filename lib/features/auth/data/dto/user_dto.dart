import '../../domain/user_model.dart';

class UserDto {
  final String id;
  final String phone;
  final String? name;
  final String role;

  const UserDto({
    required this.id,
    required this.phone,
    this.name,
    required this.role,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      name: json['name'] as String?,
      role: json['role'] as String? ?? 'driver',
    );
  }

  UserModel toDomain() {
    return UserModel(
      id: id,
      phone: phone,
      name: name ?? 'Driver',
      role: role,
    );
  }
}
