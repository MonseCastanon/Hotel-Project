import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/config/theme/app_theme.dart';
import 'package:hotel_app/presentation/providers/wear/wear_provider.dart';
import 'package:hotel_app/domain/entities/wear/wear_task.dart';
import 'package:go_router/go_router.dart';

class WearDashboardScreen extends ConsumerWidget {
  const WearDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingTasks = ref.watch(pendingWearTasksProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Typical watch background
      body: Center(
        child: ClipOval( // Simulates a round watch screen for testing on a phone
          child: Container(
            color: Colors.black,
            width: 300,
            height: 300,
            child: pendingTasks.isEmpty
                ? const _EmptyTasks()
                : _TaskList(tasks: pendingTasks),
          ),
        ),
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.success, size: 60),
        const SizedBox(height: 10),
        Text(
          'Todo limpio',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18),
        ),
      ],
    );
  }
}

class _TaskList extends ConsumerWidget {
  final List<WearTask> tasks;
  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      itemCount: tasks.length + 1, // +1 for header
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                'Tareas Pendientes',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          );
        }
        final task = tasks[index - 1];
        return Card(
          color: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            leading: Icon(
              task.taskType == WearTaskType.cleaning ? Icons.cleaning_services : Icons.plumbing,
              color: Colors.white,
            ),
            title: Text(
              'Hab ${task.roomNumber}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              task.taskType.label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            onTap: () {
              // Navegar a detalle de la tarea
              context.go('/wear/task/${task.id}');
            },
          ),
        );
      },
    );
  }
}
