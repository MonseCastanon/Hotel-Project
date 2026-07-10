import 'package:flutter/material.dart';
import 'package:hotel_app/config/theme/app_theme.dart';
import 'package:hotel_app/domain/domain.dart';

/// Badge que muestra el estado de una habitación con color e icono
class RoomStatusBadge extends StatelessWidget {
  final RoomStatus status;
  final bool compact;

  const RoomStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  Color get _color => switch (status) {
        RoomStatus.available => const Color(0xFF2E7D32),
        RoomStatus.occupied => const Color(0xFFC62828),
        RoomStatus.reserved => AppColors.primary,
        RoomStatus.maintenance => const Color(0xFFE65100),
      };

  IconData get _icon => switch (status) {
        RoomStatus.available => Icons.check_circle_outline,
        RoomStatus.occupied => Icons.person,
        RoomStatus.reserved => Icons.event_available,
        RoomStatus.maintenance => Icons.build_outlined,
      };

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _color.withValues(alpha: 0.4)),
        ),
        child: Text(
          status.label,
          style: TextStyle(
            color: _color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: _color),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              color: _color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
