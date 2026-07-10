import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/config/theme/app_theme.dart';
import 'package:hotel_app/presentation/providers/rooms/rooms_provider.dart';
import 'package:hotel_app/presentation/widgets/rooms/room_card.dart';
import 'package:hotel_app/presentation/widgets/rooms/room_filter_bar.dart';

/// Pantalla principal del módulo de habitaciones
class RoomsScreen extends ConsumerWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(roomsProvider);
    final notifier = ref.read(roomsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: notifier.loadRooms,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // ── Barra de filtros ──
          RoomFilterBar(
            selectedStatus: state.selectedStatus,
            selectedType: state.selectedType,
            onStatusChanged: notifier.filterByStatus,
            onTypeChanged: notifier.filterByType,
            onClearFilters: notifier.clearFilters,
          ),
          const SizedBox(height: 8),

          // ── Contador de resultados ──
          if (!state.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${state.rooms.length} habitaciones encontradas',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),

          // ── Lista ──
          Expanded(child: _buildBody(context, state, notifier)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, RoomsState state, RoomsNotifier notifier) {
    if (state.isLoading && state.rooms.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.rooms.isEmpty) {
      return _ErrorView(
        message: state.errorMessage!,
        onRetry: notifier.loadRooms,
      );
    }

    if (state.rooms.isEmpty) {
      return const _EmptyView();
    }

    return RefreshIndicator(
      onRefresh: notifier.loadRooms,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: state.rooms.length,
        itemBuilder: (_, i) => RoomCard(
          room: state.rooms[i],
          onTap: () => context.pushNamed(
            'roomDetail',
            pathParameters: {'roomId': state.rooms[i].id},
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: AppColors.secondary),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.hotel, size: 64, color: AppColors.secondary),
          const SizedBox(height: 16),
          Text(
            'No hay habitaciones disponibles\ncon los filtros seleccionados.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}


