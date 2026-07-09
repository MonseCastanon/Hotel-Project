import 'package:hotel_app/domain/domain.dart';

/// Modelo de datos de Habitación para la capa de infraestructura.
/// Maneja la serialización/deserialización JSON del API.
class RoomModel {
  final String id;
  final int roomNumber;
  final String roomType;
  final String status;
  final double pricePerNight;
  final String description;
  final List<String> images;
  final int capacity;
  final List<String> amenities;

  const RoomModel({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.status,
    required this.pricePerNight,
    required this.description,
    required this.images,
    required this.capacity,
    required this.amenities,
  });

  /// Construye un [RoomModel] desde un mapa JSON del API
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id']?.toString() ?? '',
      roomNumber: (json['roomNumber'] ?? json['room_number'] ?? 0) as int,
      roomType: json['roomType'] ?? json['room_type'] ?? 'single',
      status: json['status'] ?? 'available',
      pricePerNight:
          (json['pricePerNight'] ?? json['price_per_night'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      capacity: (json['capacity'] ?? 1) as int,
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }

  /// Serializa el modelo a un mapa JSON para enviar al API
  Map<String, dynamic> toJson() => {
        'id': id,
        'roomNumber': roomNumber,
        'roomType': roomType,
        'status': status,
        'pricePerNight': pricePerNight,
        'description': description,
        'images': images,
        'capacity': capacity,
        'amenities': amenities,
      };

  /// Convierte el [RoomModel] a la entidad de dominio [Room]
  Room toEntity() {
    return Room(
      id: id,
      roomNumber: roomNumber,
      roomType: _parseRoomType(roomType),
      status: _parseRoomStatus(status),
      pricePerNight: pricePerNight,
      description: description,
      images: images,
      capacity: capacity,
      amenities: amenities,
    );
  }

  /// Construye un [RoomModel] desde una entidad de dominio [Room]
  factory RoomModel.fromEntity(Room room) {
    return RoomModel(
      id: room.id,
      roomNumber: room.roomNumber,
      roomType: room.roomType.name,
      status: room.status.name,
      pricePerNight: room.pricePerNight,
      description: room.description,
      images: room.images,
      capacity: room.capacity,
      amenities: room.amenities,
    );
  }

  static RoomType _parseRoomType(String value) {
    return RoomType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RoomType.single,
    );
  }

  static RoomStatus _parseRoomStatus(String value) {
    return RoomStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RoomStatus.available,
    );
  }
}
