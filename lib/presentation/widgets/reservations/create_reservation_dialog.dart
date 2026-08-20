import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/domain/domain.dart';
import 'package:hotel_app/config/theme/app_theme.dart';
import 'package:hotel_app/presentation/providers/reservations/reservations_provider.dart';

class CreateReservationDialog extends ConsumerStatefulWidget {
  const CreateReservationDialog({super.key});

  @override
  ConsumerState<CreateReservationDialog> createState() => _CreateReservationDialogState();
}

class _CreateReservationDialogState extends ConsumerState<CreateReservationDialog> {
  final _formKey = GlobalKey<FormState>();
  String _guestName = '';
  String _roomId = '';
  DateTime? _checkIn;
  DateTime? _checkOut;
  String _notes = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(reservationsProvider.notifier);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Nueva Reservación',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre del Huésped', prefixIcon: Icon(Icons.person)),
                validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
                onSaved: (val) => _guestName = val ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Habitación (ej. room-101)', prefixIcon: Icon(Icons.meeting_room)),
                validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
                onSaved: (val) => _roomId = val ?? '',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(_checkIn == null ? 'Check-In' : '${_checkIn!.day}/${_checkIn!.month}'),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) setState(() => _checkIn = date);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(_checkOut == null ? 'Check-Out' : '${_checkOut!.day}/${_checkOut!.month}'),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _checkIn ?? DateTime.now(),
                          firstDate: _checkIn ?? DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) setState(() => _checkOut = date);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notas (opcional)', prefixIcon: Icon(Icons.note)),
                onSaved: (val) => _notes = val ?? '',
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _checkIn != null && _checkOut != null) {
                      _formKey.currentState!.save();
                      setState(() => _isLoading = true);
                      try {
                        await notifier.createReservation(
                          CreateReservationParams(
                            roomId: _roomId,
                            guestId: 'guest-${DateTime.now().millisecondsSinceEpoch}',
                            guestName: _guestName,
                            checkIn: _checkIn!,
                            checkOut: _checkOut!,
                            notes: _notes,
                          ),
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reservación creada')));
                        }
                      } catch (e) {
                        if (mounted) setState(() => _isLoading = false);
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    } else if (_checkIn == null || _checkOut == null) {
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona fechas')));
                    }
                  },
                  child: const Text('Crear Reservación', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
