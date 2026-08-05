import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/infrastructure/services/firebase_task_service.dart';

// ─────────────────────────── Providers de tareas activas ─────────────────────

/// Stream de tareas activas desde Firestore (pendientes + en progreso).
/// Se actualiza automáticamente cuando el wearable cambia el estado.
final activeTasksProvider = StreamProvider<List<HotelTask>>((ref) {
  final service = ref.watch(firebaseTaskServiceProvider);
  return service.watchActiveTasks();
});

/// Número de tareas activas — útil para badges en navegación.
final activeTaskCountProvider = Provider<int>((ref) {
  return ref.watch(activeTasksProvider).when(
        data: (tasks) => tasks.length,
        loading: () => 0,
        error: (e, st) => 0,
      );
});

/// Tareas activas solo pendientes (aún no aceptadas por el wearable).
final pendingTasksProvider = Provider<List<HotelTask>>((ref) {
  return ref.watch(activeTasksProvider).when(
        data: (tasks) => tasks.where((t) => t.status == 'pending').toList(),
        loading: () => [],
        error: (e, st) => [],
      );
});

/// Tareas activas en progreso (aceptadas y siendo trabajadas en el wearable).
final inProgressTasksProvider = Provider<List<HotelTask>>((ref) {
  return ref.watch(activeTasksProvider).when(
        data: (tasks) => tasks.where((t) => t.status == 'inProgress').toList(),
        loading: () => [],
        error: (e, st) => [],
      );
});
