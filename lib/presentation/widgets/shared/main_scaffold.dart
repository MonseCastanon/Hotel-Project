import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/config/theme/app_theme.dart';

/// Scaffold principal que contiene la BottomNavigationBar.
/// Envuelve las cuatro pantallas principales: Dashboard, Habitaciones, Reservaciones, Perfil.
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Vuelve al root de cada branch cuando se toca el tab activo
          initialLocation: index == navigationShell.currentIndex,
        ),
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
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.bed_outlined),
          selectedIcon: Icon(Icons.bed_rounded, color: AppColors.primary),
          label: 'Habitaciones',
        ),
        NavigationDestination(
          icon: Icon(Icons.event_note_outlined),
          selectedIcon:
              Icon(Icons.event_note_rounded, color: AppColors.primary),
          label: 'Reservaciones',
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
