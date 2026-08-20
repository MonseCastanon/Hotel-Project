import 'package:hotel_app/domain/domain.dart';

/// Modelo de datos de Reservación para la capa de infraestructura.
/// Maneja la serialización/deserialización JSON del API.
class ReservationModel {
  final String id;
  final String roomId;
  final String guestId;
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;
  final String status;
  final double total;
  final DateTime createdAt;
  final String? notes;

  const ReservationModel({
    required this.id,
    required this.roomId,
    required this.guestId,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.total,
    required this.createdAt,
    this.notes,
  });

  /// Construye un [ReservationModel] desde un mapa JSON del API
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id']?.toString() ?? '',
      roomId: (json['roomId'] ?? json['room_id'] ?? '').toString(),
      guestId: (json['guestId'] ?? json['guest_id'] ?? '').toString(),
      guestName: json['guestName'] ?? json['guest_name'] ?? '',
      checkIn: DateTime.parse(json['checkIn'] ?? json['check_in']),
      checkOut: DateTime.parse(json['checkOut'] ?? json['check_out']),
      status: json['status'] ?? 'pending',
      total: (json['total'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
          json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      notes: json['notes'],
    );
  }

  /// Serializa el modelo a un mapa JSON para enviar al API
  Map<String, dynamic> toJson() => {
        'id': id,
        'roomId': roomId,
        'guestId': guestId,
        'guestName': guestName,
        'checkIn': checkIn.toIso8601String(),
        'checkOut': checkOut.toIso8601String(),
        'status': status,
        'total': total,
        'createdAt': createdAt.toIso8601String(),
        if (notes != null) 'notes': notes,
      };

  /// Convierte el [ReservationModel] a la entidad de dominio [Reservation]
  Reservation toEntity() {
    return Reservation(
      id: id,
      roomId: roomId,
      guestId: guestId,
      guestName: guestName,
      checkIn: checkIn,
      checkOut: checkOut,
      status: _parseStatus(status),
      total: total,
      createdAt: createdAt,
      notes: notes,
    );
  }

  /// Construye un [ReservationModel] desde una entidad de dominio [Reservation]
  factory ReservationModel.fromEntity(Reservation reservation) {
    return ReservationModel(
      id: reservation.id,
      roomId: reservation.roomId,
      guestId: reservation.guestId,
      guestName: reservation.guestName,
      checkIn: reservation.checkIn,
      checkOut: reservation.checkOut,
      status: reservation.status.name,
      total: reservation.total,
      createdAt: reservation.createdAt,
      notes: reservation.notes,
    );
  }

  static ReservationStatus _parseStatus(String value) {
    return ReservationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ReservationStatus.newReservation,
    );
  }
}
