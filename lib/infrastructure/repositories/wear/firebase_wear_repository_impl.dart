import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_app/domain/entities/wear/wear_alert.dart';
import 'package:hotel_app/domain/entities/wear/wear_notification.dart';
import 'package:hotel_app/domain/entities/wear/wear_task.dart';
import 'package:hotel_app/domain/repositories/wear/wear_repository.dart';

class FirebaseWearRepositoryImpl implements WearRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> acceptTask(String taskId) async {
    await _firestore.collection('wear_tasks').doc(taskId).update({
      'status': WearTaskStatus.inProgress.name,
    });
  }

  @override
  Future<void> acknowledgeAlert(String alertId) async {
    await _firestore.collection('wear_alerts').doc(alertId).update({
      'isAcknowledged': true,
      'acknowledgedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> cancelTask(String taskId) async {
    await _firestore.collection('wear_tasks').doc(taskId).update({
      'status': WearTaskStatus.cancelled.name,
    });
  }

  @override
  Future<void> createTask(WearTask task) async {
    await _firestore.collection('wear_tasks').add({
      'roomId': task.roomId,
      'roomNumber': task.roomNumber,
      'taskType': task.taskType.name,
      'status': task.status.name,
      'description': task.description,
      'createdAt': FieldValue.serverTimestamp(),
      'priority': task.priority,
    });
  }

  @override
  Future<void> completeTask(String taskId, {String? notes}) async {
    await _firestore.collection('wear_tasks').doc(taskId).update({
      'status': WearTaskStatus.completed.name,
      'completedAt': FieldValue.serverTimestamp(),
      if (notes != null) 'notes': notes,
    });
  }

  @override
  Future<List<WearAlert>> getAlerts() {
    return Future.value([]);
  }

  @override
  Future<List<WearNotification>> getNotifications() {
    return Future.value([]);
  }

  @override
  Stream<Map<String, dynamic>> getRealtimeUpdates() {
    return const Stream.empty();
  }

  @override
  Future<WearTask?> getTaskById(String taskId) async {
    final doc = await _firestore.collection('wear_tasks').doc(taskId).get();
    if (!doc.exists) return null;
    return _docToTask(doc);
  }

  @override
  Future<List<WearTask>> getTasks() async {
    final qs = await _firestore.collection('wear_tasks').get();
    return qs.docs.map(_docToTask).toList();
  }

  @override
  Future<List<WearTask>> getTasksByStatus(WearTaskStatus status) async {
    final qs = await _firestore
        .collection('wear_tasks')
        .where('status', isEqualTo: status.name)
        .get();
    return qs.docs.map(_docToTask).toList();
  }

  @override
  Future<List<WearAlert>> getUnacknowledgedAlerts() {
    return Future.value([]);
  }

  @override
  Future<List<WearNotification>> getUnreadNotifications() {
    return Future.value([]);
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore.collection('wear_notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  @override
  Future<void> startTask(String taskId) async {
    await acceptTask(taskId);
  }

  // Stream custom for riverpod to listen to tasks
  Stream<List<WearTask>> watchTasks() {
    return _firestore
        .collection('wear_tasks')
        .snapshots()
        .map((qs) => qs.docs.map(_docToTask).toList());
  }

  WearTask _docToTask(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WearTask(
      id: doc.id,
      roomId: data['roomId'] ?? '',
      roomNumber: data['roomNumber'] ?? 0,
      taskType: _parseTaskType(data['taskType']),
      status: _parseTaskStatus(data['status']),
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      assignedTo: data['assignedTo'],
      priority: data['priority'] ?? 3,
    );
  }

  WearTaskType _parseTaskType(String? type) {
    return WearTaskType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => WearTaskType.cleaning,
    );
  }

  WearTaskStatus _parseTaskStatus(String? status) {
    return WearTaskStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => WearTaskStatus.pending,
    );
  }
}
