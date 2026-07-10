import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/domain/domain.dart';
import 'package:hotel_app/infrastructure/infraestructure.dart';
import 'package:hotel_app/presentation/providers/rooms/rooms_provider.dart';

// ─────────────────────────── Infraestructura ────────────────────────────────

final reservationsDataSourceProvider = Provider<ReservationsDataSource>((ref) {
  return ReservationsDataSourceImpl(ref.watch(dioProvider));
});

final reservationsRepositoryProvider = Provider<ReservationsRepository>((ref) {
  return ReservationsRepositoryImpl(ref.watch(reservationsDataSourceProvider));
});

// ───────────────────────────── Estado ────────────────────────────────────────

class CheckInOutState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final Reservation? updatedReservation;

  const CheckInOutState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.updatedReservation,
  });

  CheckInOutState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    Reservation? updatedReservation,
    bool clearMessages = false,
  }) {
    return CheckInOutState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearMessages ? null : errorMessage ?? this.errorMessage,
      successMessage:
          clearMessages ? null : successMessage ?? this.successMessage,
      updatedReservation: updatedReservation ?? this.updatedReservation,
    );
  }
}

// ─────────────────────────── Notifier (Riverpod 3) ───────────────────────────

class CheckInOutNotifier extends Notifier<CheckInOutState> {
  @override
  CheckInOutState build() => const CheckInOutState();

  ReservationsRepository get _repository =>
      ref.read(reservationsRepositoryProvider);

  /// Realiza el check-in de una reservación
  Future<bool> performCheckIn(String reservationId) async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final reservation = await _repository.checkIn(reservationId);
      state = state.copyWith(
        isLoading: false,
        updatedReservation: reservation,
        successMessage: 'Check-in realizado exitosamente.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  /// Realiza el check-out de una reservación
  Future<bool> performCheckOut(String reservationId) async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final reservation = await _repository.checkOut(reservationId);
      state = state.copyWith(
        isLoading: false,
        updatedReservation: reservation,
        successMessage: 'Check-out realizado exitosamente.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  void clearMessages() => state = state.copyWith(clearMessages: true);
}

/// Provider del manejo de check-in y check-out
final checkInOutProvider =
    NotifierProvider<CheckInOutNotifier, CheckInOutState>(
  CheckInOutNotifier.new,
);
