import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/config/theme/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/presentation/providers/auth/auth_provider.dart';
import 'package:hotel_app/domain/entities/user.dart';

/// Scaffold principal que contiene la BottomNavigationBar y un menú lateral.
class MainScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authProvider).role ?? UserRole.unassigned;

    return Scaffold(
      drawer: _DynamicDrawer(role: role),
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          // Bloquear navegacion a reservaciones (index 2) para mucamas y mantenimiento
          if (index == 2 && (role == UserRole.housekeeper || role == UserRole.maintenance)) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('No tienes permisos para ver las reservaciones.'))
             );
             return;
          }
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class _DynamicDrawer extends ConsumerWidget {
  final UserRole role;

  const _DynamicDrawer({required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(authProvider).name ?? 'Usuario';
    final userEmail = ref.watch(authProvider).email ?? '';

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text('$userEmail\n${role.label}'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.primary),
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    context.pop(); // close drawer
                    context.go('/dashboard');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bed),
                  title: const Text('Habitaciones'),
                  onTap: () {
                    context.pop();
                    context.go('/rooms');
                  },
                ),
                if (role == UserRole.admin || role == UserRole.receptionist)
                  ListTile(
                    leading: const Icon(Icons.event_note),
                    title: const Text('Reservaciones'),
                    onTap: () {
                      context.pop();
                      context.go('/reservations');
                    },
                  ),
                if (role == UserRole.admin) ...[
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Administración', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Empleados'),
                    onTap: () {
                      context.pop();
                      context.push('/admin/employees');
                    },
                  ),
                ],
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: AppColors.primary.withValues(alpha: 0.15),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primary),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.bed_outlined),
          selectedIcon: Icon(Icons.bed_rounded, color: AppColors.primary),
          label: 'Cuartos',
        ),
        NavigationDestination(
          icon: Icon(Icons.event_note_outlined),
          selectedIcon:
              Icon(Icons.event_note_rounded, color: AppColors.primary),
          label: 'Reservas',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
          label: 'Perfil',
        ),
      ],
    );
  }
}
