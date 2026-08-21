import 'package:hotel_app/domain/domain.dart';
import 'package:hotel_app/infrastructure/models/rooms/room_model.dart';

/// Mapper para convertir entre [RoomModel] y la entidad de dominio [Room].
/// Centraliza la lógica de conversión para mantener los modelos y entidades desacoplados.
class RoomMapper {
  RoomMapper._();

  /// Convierte un [RoomModel] (datos del API/BD) a entidad de dominio [Room]
  static Room fromModel(RoomModel model) => model.toEntity();

  /// Convierte una entidad de dominio [Room] a [RoomModel]
  static RoomModel toModel(Room entity) => RoomModel.fromEntity(entity);

  /// Convierte un mapa JSON directamente a entidad de dominio [Room]
  static Room fromJson(Map<String, dynamic> json) =>
      RoomModel.fromJson(json).toEntity();

  /// Convierte una lista de mapas JSON a lista de entidades [Room]
  static List<Room> fromJsonList(List<dynamic> jsonList) =>
      jsonList
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
}
