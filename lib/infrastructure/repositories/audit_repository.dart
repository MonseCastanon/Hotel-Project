import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_app/domain/entities/audit_log.dart';

class AuditRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logAction({
    required String action,
    required String description,
    required String performedBy,
    required String targetId,
  }) async {
    try {
      final docRef = _firestore.collection('audit_logs').doc();
      final log = AuditLog(
        id: docRef.id,
        action: action,
        description: description,
        performedBy: performedBy,
        targetId: targetId,
        timestamp: DateTime.now(),
      );
      await docRef.set(log.toMap());
    } catch (e) {
      print('Error guardando log de auditoría: $e');
    }
  }
}
