import 'package:hotel_app/domain/domain.dart';
import 'package:hotel_app/infrastructure/models/reservation/reservation_model.dart';

/// Mapper para convertir entre [ReservationModel] y la entidad de dominio [Reservation].
/// Centraliza la lógica de conversión para mantener los modelos y entidades desacoplados.
class ReservationMapper {
  ReservationMapper._();

  /// Convierte un [ReservationModel] (datos del API/BD) a entidad de dominio [Reservation]
  static Reservation fromModel(ReservationModel model) => model.toEntity();

  /// Convierte una entidad de dominio [Reservation] a [ReservationModel]
  static ReservationModel toModel(Reservation entity) =>
      ReservationModel.fromEntity(entity);

  /// Convierte un mapa JSON directamente a entidad de dominio [Reservation]
  static Reservation fromJson(Map<String, dynamic> json) =>
      ReservationModel.fromJson(json).toEntity();

  /// Convierte una lista de mapas JSON a lista de entidades [Reservation]
  static List<Reservation> fromJsonList(List<dynamic> jsonList) =>
      jsonList
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
}
