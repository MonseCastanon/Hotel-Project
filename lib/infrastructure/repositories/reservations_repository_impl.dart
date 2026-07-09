import 'package:hotel_app/domain/domain.dart';

/// Implementación concreta de [ReservationsRepository].
/// Delega las operaciones al [ReservationsDataSource] (API remota).
class ReservationsRepositoryImpl implements ReservationsRepository {
  final ReservationsDataSource _dataSource;

  const ReservationsRepositoryImpl(this._dataSource);

  @override
  Future<List<Reservation>> getReservations({
    ReservationStatus? status,
    String? guestId,
  }) {
    return _dataSource.getReservations(status: status, guestId: guestId);
  }

  @override
  Future<Reservation> getReservationById(String id) {
    return _dataSource.getReservationById(id);
  }

  @override
  Future<Reservation> createReservation(CreateReservationParams params) {
    return _dataSource.createReservation(params);
  }

  @override
  Future<Reservation> checkIn(String reservationId) {
    return _dataSource.checkIn(reservationId);
  }

  @override
  Future<Reservation> checkOut(String reservationId) {
    return _dataSource.checkOut(reservationId);
  }

  @override
  Future<Reservation> cancelReservation(String reservationId) {
    return _dataSource.cancelReservation(reservationId);
  }
}
