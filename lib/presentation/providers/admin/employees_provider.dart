import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/domain/entities/user.dart';
import 'package:hotel_app/infrastructure/services/email_service.dart';
import 'package:hotel_app/infrastructure/repositories/audit_repository.dart';
import 'package:hotel_app/presentation/providers/auth/auth_provider.dart';

final employeesStreamProvider = StreamProvider.autoDispose<List<User>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      
      final roleStr = data['role'] as String? ?? 'unassigned';
      final statusStr = data['status'] as String? ?? 'active';
      
      return User(
        id: doc.id,
        name: data['name'] as String? ?? 'Desconocido',
        email: data['email'] as String? ?? '',
        role: UserRole.values.firstWhere(
          (e) => e.name == roleStr,
          orElse: () => UserRole.unassigned,
        ),
        status: UserStatus.values.firstWhere(
          (e) => e.name == statusStr,
          orElse: () => UserStatus.pending,
        ),
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  });
});

class EmployeesNotifier extends Notifier<bool> {
  @override
  bool build() => false; // isLoading

  Future<void> updateEmployeeRoleAndStatus(
      String userId, UserRole newRole, UserStatus newStatus) async {
    state = true;
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': newRole.name,
        'status': newStatus.name,
      });
      
      // Si el estado es activo, mandar correo de aprobación
      if (newStatus == UserStatus.active) {
        // Consultar el usuario para tener su email y nombre completos
        final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (doc.exists) {
          final data = doc.data()!;
          final employee = User(
            id: doc.id,
            name: data['name'] as String? ?? 'Desconocido',
            email: data['email'] as String? ?? '',
            role: newRole,
            status: newStatus,
            createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          );
          await EmailService.sendApprovalEmail(employee);
        }
      }
      
      // Registrar en Auditoría
      final managerEmail = ref.read(authProvider).email ?? 'gerente@desconocido.com';
      final auditRepo = AuditRepository();
      await auditRepo.logAction(
        action: 'UPDATE_EMPLOYEE',
        description: 'Se cambió el estado a ${newStatus.label} y rol a ${newRole.label} del usuario $userId',
        performedBy: managerEmail,
        targetId: userId,
      );

    } finally {
      state = false;
    }
  }
}

final employeesProvider =
    NotifierProvider<EmployeesNotifier, bool>(EmployeesNotifier.new);
