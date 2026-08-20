import 'package:hotel_app/domain/domain.dart';

/// DataSource local con datos de prueba para reservaciones.
class ReservationsLocalDataSource implements ReservationsDataSource {
  static final List<Reservation> _mockReservations = [
    Reservation(
      id: 'res-001',
      roomId: '2',
      guestId: 'guest-01',
      guestName: 'Carlos Mendoza',
      checkIn: DateTime.now().subtract(const Duration(days: 1)),
      checkOut: DateTime.now().add(const Duration(days: 2)),
      status: ReservationStatus.checkedIn,
      total: 3600,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      notes: 'Solicita cuna adicional',
    ),
    Reservation(
      id: 'res-002',
      roomId: '4',
      guestId: 'guest-02',
      guestName: 'María García López',
      checkIn: DateTime.now().add(const Duration(days: 1)),
      checkOut: DateTime.now().add(const Duration(days: 4)),
      status: ReservationStatus.confirmed,
      total: 3450,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Reservation(
      id: 'res-003',
      roomId: '5',
      guestId: 'guest-03',
      guestName: 'Roberto Silva',
      checkIn: DateTime.now().add(const Duration(days: 3)),
      checkOut: DateTime.now().add(const Duration(days: 6)),
      status: ReservationStatus.newReservation,
      total: 5700,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Reservation(
      id: 'res-004',
      roomId: '3',
      guestId: 'guest-04',
      guestName: 'Ana Martínez',
      checkIn: DateTime.now().subtract(const Duration(days: 5)),
      checkOut: DateTime.now().subtract(const Duration(days: 2)),
      status: ReservationStatus.completed,
      total: 8400,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Reservation(
      id: 'res-005',
      roomId: '1',
      guestId: 'guest-05',
      guestName: 'Jorge Ramírez',
      checkIn: DateTime.now().add(const Duration(days: 7)),
      checkOut: DateTime.now().add(const Duration(days: 9)),
      status: ReservationStatus.confirmed,
      total: 1700,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<Reservation>> getReservations({
    ReservationStatus? status,
    String? guestId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    var list = List<Reservation>.from(_mockReservations);
    if (status != null) list = list.where((r) => r.status == status).toList();
    if (guestId != null) list = list.where((r) => r.guestId == guestId).toList();
    return list;
  }

  @override
  Future<Reservation> getReservationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockReservations.firstWhere(
      (r) => r.id == id,
      orElse: () => throw Exception('Reservación no encontrada'),
    );
  }

  @override
  Future<Reservation> createReservation(CreateReservationParams params) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final newReservation = Reservation(
      id: 'res-${DateTime.now().millisecondsSinceEpoch}',
      roomId: params.roomId,
      guestId: params.guestId,
      guestName: params.guestName,
      checkIn: params.checkIn,
      checkOut: params.checkOut,
      status: ReservationStatus.newReservation,
      total: 0,
      createdAt: DateTime.now(),
      notes: params.notes,
    );
    _mockReservations.add(newReservation);
    return newReservation;
  }

  @override
  Future<Reservation> checkIn(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockReservations.indexWhere((r) => r.id == reservationId);
    if (index == -1) throw Exception('Reservación no encontrada');
    final updated = _mockReservations[index].copyWith(
      status: ReservationStatus.checkedIn,
    );
    _mockReservations[index] = updated;
    return updated;
  }

  @override
  Future<Reservation> checkOut(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockReservations.indexWhere((r) => r.id == reservationId);
    if (index == -1) throw Exception('Reservación no encontrada');
    final updated = _mockReservations[index].copyWith(
      status: ReservationStatus.completed,
    );
    _mockReservations[index] = updated;
    return updated;
  }

  @override
  Future<Reservation> cancelReservation(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockReservations.indexWhere((r) => r.id == reservationId);
    if (index == -1) throw Exception('Reservación no encontrada');
    final updated = _mockReservations[index].copyWith(
      status: ReservationStatus.cancelled,
    );
    _mockReservations[index] = updated;
    return updated;
  }
}
