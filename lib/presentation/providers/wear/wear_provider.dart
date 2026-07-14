import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/domain/entities/wear/wear_task.dart';
import 'package:hotel_app/domain/repositories/wear/wear_repository.dart';
import 'package:hotel_app/infrastructure/repositories/wear/firebase_wear_repository_impl.dart';

// Repositorio de Firebase
final wearRepositoryProvider = Provider<WearRepository>((ref) {
  return FirebaseWearRepositoryImpl();
});

// Stream para tareas activas
final wearTasksStreamProvider = StreamProvider<List<WearTask>>((ref) {
  final repo = ref.watch(wearRepositoryProvider) as FirebaseWearRepositoryImpl;
  return repo.watchTasks();
});

// Tareas pendientes
final pendingWearTasksProvider = Provider<List<WearTask>>((ref) {
  final tasks = ref.watch(wearTasksStreamProvider).value ?? [];
  return tasks.where((t) => t.status == WearTaskStatus.pending).toList();
});

// Tareas en progreso
final inProgressWearTasksProvider = Provider<List<WearTask>>((ref) {
  final tasks = ref.watch(wearTasksStreamProvider).value ?? [];
  return tasks.where((t) => t.status == WearTaskStatus.inProgress).toList();
});
