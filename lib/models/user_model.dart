enum UserRole {
  driver,
  dhaba,
  mechanic,
  admin,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.driver:
        return 'Driver / Traveler';
      case UserRole.dhaba:
        return 'Dhaba Owner';
      case UserRole.mechanic:
        return 'Mechanic Service';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  String get keyName => name;
}

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final UserRole role;
  final String? vehicleNumber;
  final String? vehicleType;
  final String? businessName;
  final String? avatarUrl;
  final bool isAvailable;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    this.vehicleNumber,
    this.vehicleType,
    this.businessName,
    this.avatarUrl,
    this.isAvailable = true,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    UserRole? role,
    String? vehicleNumber,
    String? vehicleType,
    String? businessName,
    String? avatarUrl,
    bool? isAvailable,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      businessName: businessName ?? this.businessName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
