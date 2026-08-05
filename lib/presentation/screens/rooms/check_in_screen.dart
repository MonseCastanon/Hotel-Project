import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/config/theme/app_theme.dart';
import 'package:hotel_app/presentation/providers/rooms/check_in_out_provider.dart';

/// Pantalla de Check-in
class CheckInScreen extends ConsumerWidget {
  final String reservationId;
  final String guestName;
  final String roomNumber;

  const CheckInScreen({
    super.key,
    required this.reservationId,
    required this.guestName,
    required this.roomNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkInOutProvider);
    final notifier = ref.read(checkInOutProvider.notifier);

    // Listener para navegar al éxito
    ref.listen<CheckInOutState>(checkInOutProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green[700],
          ),
        );
        notifier.clearMessages();
        if (context.mounted) context.pop(true); // regresa true = éxito
      }
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red[700],
          ),
        );
        notifier.clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ícono ──
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.login, size: 48, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),

            // ── Información ──
            _InfoRow(label: 'Huésped', value: guestName, icon: Icons.person_outline),
            const Divider(height: 24),
            _InfoRow(label: 'Habitación', value: 'No. $roomNumber', icon: Icons.hotel),
            const Divider(height: 24),
            _InfoRow(
              label: 'Fecha de entrada',
              value: _formatDate(DateTime.now()),
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 40),

            // ── Aviso ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Al confirmar, el estado de la reservación cambiará a "Check-in realizado" y la habitación quedará ocupada.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // ── Botón ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () => notifier.performCheckIn(reservationId, roomNumber),
                icon: state.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.login),
                label: Text(state.isLoading ? 'Procesando...' : 'Confirmar Check-in'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
