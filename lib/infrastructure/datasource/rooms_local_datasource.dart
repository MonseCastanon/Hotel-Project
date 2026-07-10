import 'package:hotel_app/domain/domain.dart';

/// DataSource local con datos de prueba para desarrollo sin backend.
/// Simula la respuesta del API con un delay artificial para imitar una llamada real.
class RoomsLocalDataSource implements RoomsDataSource {
  static final List<Room> _mockRooms = [
    Room(
      id: '1',
      roomNumber: 101,
      roomType: RoomType.single,
      status: RoomStatus.available,
      pricePerNight: 850,
      description:
          'Habitación sencilla con cama individual, perfecta para viajeros de negocios. Cuenta con escritorio, wifi de alta velocidad y vista al jardín interior.',
      images: [],
      capacity: 1,
      amenities: ['WiFi', 'TV 43"', 'Aire acondicionado', 'Caja fuerte'],
    ),
    Room(
      id: '2',
      roomNumber: 201,
      roomType: RoomType.double,
      status: RoomStatus.occupied,
      pricePerNight: 1200,
      description:
          'Habitación doble con cama king size y sofá. Ideal para parejas o viajeros que buscan mayor comodidad y espacio.',
      images: [],
      capacity: 2,
      amenities: ['WiFi', 'TV 55"', 'Aire acondicionado', 'Minibar', 'Caja fuerte', 'Balcón'],
    ),
    Room(
      id: '3',
      roomNumber: 301,
      roomType: RoomType.suite,
      status: RoomStatus.available,
      pricePerNight: 2800,
      description:
          'Suite de lujo con sala de estar separada, jacuzzi y vista panorámica a la ciudad. Incluye servicio de mayordomo personalizado.',
      images: [],
      capacity: 2,
      amenities: ['WiFi Premium', 'TV 65"', 'Jacuzzi', 'Sala de estar', 'Mayordomo', 'Minibar', 'Desayuno incluido'],
    ),
    Room(
      id: '4',
      roomNumber: 202,
      roomType: RoomType.double,
      status: RoomStatus.reserved,
      pricePerNight: 1150,
      description:
          'Habitación doble con dos camas matrimoniales. Excelente opción para familias pequeñas o compañeros de viaje.',
      images: [],
      capacity: 4,
      amenities: ['WiFi', 'TV 50"', 'Aire acondicionado', 'Caja fuerte'],
    ),
    Room(
      id: '5',
      roomNumber: 401,
      roomType: RoomType.deluxe,
      status: RoomStatus.available,
      pricePerNight: 1900,
      description:
          'Habitación deluxe con decoración premium, cama king size y baño con tina de mármol. Vista directa a la alberca.',
      images: [],
      capacity: 2,
      amenities: ['WiFi Premium', 'TV 60"', 'Tina de mármol', 'Balcón', 'Minibar', 'Servicio a cuarto 24h'],
    ),
    Room(
      id: '6',
      roomNumber: 102,
      roomType: RoomType.single,
      status: RoomStatus.maintenance,
      pricePerNight: 820,
      description:
          'Habitación sencilla en proceso de renovación. Disponible próximamente con nuevas instalaciones.',
      images: [],
      capacity: 1,
      amenities: ['WiFi', 'TV', 'Aire acondicionado'],
    ),
    Room(
      id: '7',
      roomNumber: 501,
      roomType: RoomType.penthouse,
      status: RoomStatus.available,
      pricePerNight: 5500,
      description:
          'Penthouse exclusivo en el último piso con terraza privada, alberca de uso exclusivo y vista de 360° a la ciudad. La experiencia definitiva de lujo.',
      images: [],
      capacity: 4,
      amenities: [
        'WiFi Premium', 'TV 75"', 'Alberca privada', 'Terraza', 'Chef privado',
        'Mayordomo', 'Jacuzzi', 'Sala de cine', 'Desayuno gourmet'
      ],
    ),
  ];

  @override
  Future<List<Room>> getRooms({RoomStatus? status, RoomType? type}) async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 600));

    var rooms = List<Room>.from(_mockRooms);
    if (status != null) rooms = rooms.where((r) => r.status == status).toList();
    if (type != null) rooms = rooms.where((r) => r.roomType == type).toList();
    return rooms;
  }

  @override
  Future<Room> getRoomById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockRooms.firstWhere(
      (r) => r.id == id,
      orElse: () => throw Exception('Habitación no encontrada'),
    );
  }

  @override
  Future<Room> updateRoomStatus(String id, RoomStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockRooms.indexWhere((r) => r.id == id);
    if (index == -1) throw Exception('Habitación no encontrada');
    final updated = _mockRooms[index].copyWith(status: newStatus);
    _mockRooms[index] = updated;
    return updated;
  }
}
