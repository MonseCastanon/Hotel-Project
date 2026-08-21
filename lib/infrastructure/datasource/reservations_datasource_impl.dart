import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_app/domain/domain.dart';
import 'package:hotel_app/infrastructure/mappers/reservation_mapper.dart';
import 'package:hotel_app/infrastructure/models/reservation/reservation_model.dart';

/// Implementación concreta de [ReservationsDataSource] usando Firebase Firestore.
class ReservationsDataSourceImpl implements ReservationsDataSource {
  final FirebaseFirestore _firestore;

  ReservationsDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _reservations =>
      _firestore.collection('reservations');

  @override
  Future<List<Reservation>> getReservations({
    ReservationStatus? status,
    String? guestId,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _reservations;

      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }
      if (guestId != null) {
        query = query.where('guestId', isEqualTo: guestId);
      }

      final snapshot = await query.get();
      final reservations = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ReservationMapper.fromJson(data);
      }).toList();

      return reservations;
    } catch (e) {
      throw Exception('Error al obtener reservaciones de Firebase: $e');
    }
  }

  @override
  Future<Reservation> getReservationById(String id) async {
    try {
      final doc = await _reservations.doc(id).get();
      if (!doc.exists) throw Exception('Reservación no encontrada');
      
      final data = doc.data()!;
      data['id'] = doc.id;
      return ReservationMapper.fromJson(data);
    } catch (e) {
      throw Exception('Error al obtener reservación: $e');
    }
  }

  @override
  Future<Reservation> createReservation(CreateReservationParams params) async {
    try {
      // Validar que el cuarto no tenga una reservación activa
      final activeQuery = await _reservations
          .where('roomId', isEqualTo: params.roomId)
          .where('status', whereIn: ['confirmed', 'checkedIn', 'newReservation'])
          .limit(1)
          .get();

      if (activeQuery.docs.isNotEmpty) {
        throw Exception('La habitaci\u00f3n ya tiene una reservaci\u00f3n activa. Elige otra habitaci\u00f3n.');
      }

      final docRef = _reservations.doc();
      final reservation = ReservationModel(
        id: docRef.id,
        roomId: params.roomId,
        guestId: params.guestId,
        guestName: params.guestName,
        checkIn: params.checkIn,
        checkOut: params.checkOut,
        companions: 0, // Por defecto en la creación
        status: ReservationStatus.confirmed.name, // Confirmada directamente
        total: 0.0, // Se calcularía en backend/cloud function
        createdAt: DateTime.now(),
        notes: params.notes,
      );

      await docRef.set(reservation.toJson());
      return reservation.toEntity();
    } catch (e) {
      throw Exception('Error al crear reservación: $e');
    }
  }

  @override
  Future<Reservation> checkIn({
    required String reservationId,
    required String guestName,
    required int companions,
    required DateTime expectedCheckOut,
  }) async {
    try {
      await _reservations.doc(reservationId).update({
        'status': ReservationStatus.checkedIn.name,
        'guestName': guestName,
        'companions': companions,
        'checkOut': expectedCheckOut.toIso8601String(),
      });
      return await getReservationById(reservationId);
    } catch (e) {
      throw Exception('Error al realizar check-in: $e');
    }
  }

  @override
  Future<Reservation> checkOut(String reservationId) async {
    try {
      await _reservations.doc(reservationId).update({
        'status': ReservationStatus.completed.name,
      });
      return await getReservationById(reservationId);
    } catch (e) {
      throw Exception('Error al realizar check-out: $e');
    }
  }

  @override
  Future<Reservation> cancelReservation(String reservationId) async {
    try {
      await _reservations.doc(reservationId).update({
        'status': ReservationStatus.cancelled.name,
      });
      return await getReservationById(reservationId);
    } catch (e) {
      throw Exception('Error al cancelar reservación: $e');
    }
  }
}
