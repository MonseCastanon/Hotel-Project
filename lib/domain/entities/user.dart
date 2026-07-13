/// Roles de usuario disponibles en el sistema del hotel
enum UserRole {
  admin,
  receptionist,
  housekeeper,
  maintenance;

  String get label => switch (this) {
        UserRole.admin => 'Administrador',
        UserRole.receptionist => 'Recepcionista',
        UserRole.housekeeper => 'Ama de llaves',
        UserRole.maintenance => 'Mantenimiento',
      };
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatarUrl;
  final bool isActive;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.isActive = true,
    required this.createdAt,
  });

  /// Retorna true si el usuario es administrador
  bool get isAdmin => role == UserRole.admin;

  /// Retorna true si el usuario es recepcionista
  bool get isReceptionist => role == UserRole.receptionist;

  /// Crea una copia de la entidad con los campos modificados
  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? avatarUrl,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'User(id: $id, name: $name, role: ${role.label}, isActive: $isActive)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;
}