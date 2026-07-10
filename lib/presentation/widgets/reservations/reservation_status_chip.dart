import 'package:flutter/material.dart';
import 'package:hotel_app/domain/domain.dart';

/// Chip de estado para reservaciones
class ReservationStatusChip extends StatelessWidget {
  final ReservationStatus status;

  const ReservationStatusChip({super.key, required this.status});

  Color get _color => switch (status) {
        ReservationStatus.pending => const Color(0xFFE65100),
        ReservationStatus.confirmed => const Color(0xFF1565C0),
        ReservationStatus.checkedIn => const Color(0xFF2E7D32),
        ReservationStatus.checkedOut => const Color(0xFF6A1B9A),
        ReservationStatus.cancelled => const Color(0xFF616161),
      };

  IconData get _icon => switch (status) {
        ReservationStatus.pending => Icons.hourglass_empty,
        ReservationStatus.confirmed => Icons.check_circle_outline,
        ReservationStatus.checkedIn => Icons.login,
        ReservationStatus.checkedOut => Icons.logout,
        ReservationStatus.cancelled => Icons.cancel_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 13, color: _color),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              color: _color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
