import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Caso de uso: Realizar el check-in de una reservación.
/// Cambia el estado de la reservación a [ReservationStatus.checkedIn].
class CheckIn {
  final ReservationsRepository _repository;

  const CheckIn(this._repository);

  Future<Reservation> call({
    required String reservationId,
    required String guestName,
    required int companions,
    required DateTime expectedCheckOut,
  }) {
    return _repository.checkIn(
      reservationId: reservationId,
      guestName: guestName,
      companions: companions,
      expectedCheckOut: expectedCheckOut,
    );
  }
}
