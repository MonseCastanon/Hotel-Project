import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/config/theme/app_theme.dart';
import 'package:hotel_app/presentation/screens/screens.dart';

// ─────────────────────────── Nombres de rutas ────────────────────────────────

abstract class AppRoutes {
  // Habitaciones
  static const rooms = '/rooms';
  static const roomDetail = '/rooms/:roomId';

  // Reservaciones
  static const reservations = '/reservations';
}

// ─────────────────────────── GoRouter Provider ───────────────────────────────

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: _routes,
    errorBuilder: (context, state) => RouterErrorScreen(
      error: state.error?.message ?? 'Ruta no encontrada',
    ),
  );
});

// ─────────────────────────── Rutas ───────────────────────────────────────────

final List<RouteBase> _routes = [
  // ── Autenticación ───────────────────────────────────────────────────────
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginScreen(),
  ),

  // ── Habitaciones ──────────────────────────────────────────────────────────
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

  // ── Reservaciones ─────────────────────────────────────────────────────────
  GoRoute(
    path: AppRoutes.reservations,
    name: 'reservations',
    builder: (context, state) => const ReservationsScreen(),
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
                onPressed: () => context.go(AppRoutes.rooms),
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
