import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/config/theme/app_theme.dart';
import 'package:hotel_app/presentation/providers/auth/auth_provider.dart';
import 'package:hotel_app/presentation/screens/screens.dart';
import 'package:hotel_app/presentation/widgets/shared/main_scaffold.dart';

// ─────────────────────────── Nombres de rutas ────────────────────────────────

abstract class AppRoutes {
  // Inicio
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/dashboard';

  // Habitaciones
  static const rooms = '/rooms';

  // Reservaciones
  static const reservations = '/reservations';

  // Perfil
  static const profile = '/profile';
}

// ─────────────────────────── GoRouter Provider ───────────────────────────────

final goRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: _routes,
    errorBuilder: (context, state) => RouterErrorScreen(
      error: state.error?.message ?? 'Ruta no encontrada',
    ),
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // Espera a que se inicialice (loading)
      if (authState.isLoading) return null;

      final isAuthenticated = authState.isAuthenticated;
      final location = state.uri.toString();

      final isPublic = location == AppRoutes.login || location == AppRoutes.splash;

      // No autenticado → redirige a login (salvo que ya esté ahí)
      if (!isAuthenticated && !isPublic) return AppRoutes.login;

      // Autenticado y en login/splash → redirige a dashboard
      if (isAuthenticated && isPublic) return AppRoutes.dashboard;

      return null; // sin redireccion
    },
  );

  // Escucha cambios de authProvider para refrescar el router
  ref.listen(authProvider, (previous, next) {
    if (previous?.isAuthenticated != next.isAuthenticated) {
      router.refresh();
    }
  });

  return router;
});

// ─────────────────────────── Rutas ───────────────────────────────────────────

final List<RouteBase> _routes = [
  // ── Splash ──────────────────────────────────────────────────────────────
  GoRoute(
    path: AppRoutes.splash,
    name: 'splash',
    builder: (context, state) => const SplashScreen(),
  ),

  // ── Autenticación ───────────────────────────────────────────────────────
  GoRoute(
    path: AppRoutes.login,
    name: 'login',
    builder: (context, state) => const LoginScreen(),
  ),

  // ── Shell principal con Bottom Navigation ────────────────────────────────
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) =>
        MainScaffold(navigationShell: navigationShell),
    branches: [
      // Branch 0 — Dashboard
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
        ],
      ),

      // Branch 1 — Habitaciones
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.rooms,
            name: 'rooms',
            builder: (context, state) => const RoomsScreen(),
            routes: [
              // Detalle de habitación
              GoRoute(
                path: ':roomId',
                name: 'roomDetail',
                builder: (context, state) {
                  final roomId = state.pathParameters['roomId']!;
                  return RoomDetailScreen(roomId: roomId);
                },
                routes: [
                  // Check-in — datos vienen como queryParameters
                  GoRoute(
                    path: 'check-in',
                    name: 'checkIn',
                    builder: (context, state) {
                      final roomId = state.pathParameters['roomId']!;
                      final q = state.uri.queryParameters;
                      return CheckInScreen(
                        reservationId: q['reservationId'] ?? '',
                        guestName: q['guestName'] ?? '',
                        roomNumber: q['roomNumber'] ?? roomId,
                      );
                    },
                  ),
                  // Check-out — datos vienen como extra Map
                  GoRoute(
                    path: 'check-out',
                    name: 'checkOut',
                    builder: (context, state) {
                      final roomId = state.pathParameters['roomId']!;
                      final extra = state.extra as Map<String, dynamic>? ?? {};
                      return CheckOutScreen(
                        reservationId: extra['reservationId'] as String? ?? '',
                        guestName: extra['guestName'] as String? ?? '',
                        roomNumber: extra['roomNumber'] as String? ?? roomId,
                        nights: extra['nights'] as int? ?? 1,
                        total: (extra['total'] as num?)?.toDouble() ?? 0.0,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Branch 2 — Reservaciones
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.reservations,
            name: 'reservations',
            builder: (context, state) => const ReservationsScreen(),
          ),
        ],
      ),

      // Branch 3 — Perfil
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  ),
];

// ─────────────────────────── Error Screen ────────────────────────────────────

class RouterErrorScreen extends StatelessWidget {
  final String error;
  const RouterErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, size: 72, color: AppColors.secondary),
              const SizedBox(height: 20),
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.dashboard),
                icon: const Icon(Icons.home),
                label: const Text('Ir al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
