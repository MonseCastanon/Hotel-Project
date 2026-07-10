import 'package:flutter/material.dart';
import 'package:hotel_app/config/theme/app_theme.dart';
import 'package:hotel_app/domain/domain.dart';

/// Barra de filtros para la pantalla de habitaciones
class RoomFilterBar extends StatelessWidget {
  final RoomStatus? selectedStatus;
  final RoomType? selectedType;
  final ValueChanged<RoomStatus?> onStatusChanged;
  final ValueChanged<RoomType?> onTypeChanged;
  final VoidCallback onClearFilters;

  const RoomFilterBar({
    super.key,
    this.selectedStatus,
    this.selectedType,
    required this.onStatusChanged,
    required this.onTypeChanged,
    required this.onClearFilters,
  });

  bool get _hasFilters => selectedStatus != null || selectedType != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Filtros de estado ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _FilterChip(
                label: 'Todos',
                isSelected: selectedStatus == null,
                onTap: () => onStatusChanged(null),
              ),
              ...RoomStatus.values.map((s) => _FilterChip(
                    label: s.label,
                    isSelected: selectedStatus == s,
                    onTap: () =>
                        onStatusChanged(selectedStatus == s ? null : s),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // ── Filtros de tipo ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              ...RoomType.values.map((t) => _FilterChip(
                    label: t.label,
                    isSelected: selectedType == t,
                    onTap: () =>
                        onTypeChanged(selectedType == t ? null : t),
                    outlined: true,
                  )),
              if (_hasFilters)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ActionChip(
                    label: const Text('Limpiar'),
                    avatar: const Icon(Icons.close, size: 16),
                    onPressed: onClearFilters,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool outlined;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
        side: outlined
            ? const BorderSide(color: AppColors.secondary)
            : null,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : null,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
