import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/config/theme/app_theme.dart';
import 'package:hotel_app/presentation/providers/wear/wear_provider.dart';
import 'package:go_router/go_router.dart';

class WearTaskDetailScreen extends ConsumerWidget {
  final String taskId;
  const WearTaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksStream = ref.watch(wearTasksStreamProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ClipOval(
          child: Container(
            color: Colors.black,
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(20),
            child: tasksStream.when(
              data: (tasks) {
                final task = tasks.firstWhere(
                  (t) => t.id == taskId,
                  orElse: () => tasks.first, // Fallback safe
                );

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Habitación ${task.roomNumber}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Completar'),
                      onPressed: () async {
                        await ref.read(wearRepositoryProvider).completeTask(task.id);
                        if (context.mounted) {
                          context.go('/wear');
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => context.go('/wear'),
                      child: const Text('Volver', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => const Center(child: Text('Error', style: TextStyle(color: Colors.red))),
            ),
          ),
        ),
      ),
    );
  }
}
