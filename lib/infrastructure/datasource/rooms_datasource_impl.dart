import 'package:dio/dio.dart';
import 'package:hotel_app/domain/domain.dart';
import 'package:hotel_app/infrastructure/mappers/room_mapper.dart';

/// Implementación concreta de [RoomsDataSource] usando Dio para llamadas al API REST.
class RoomsDataSourceImpl implements RoomsDataSource {
  final Dio _dio;

  RoomsDataSourceImpl(this._dio);

  @override
  Future<List<Room>> getRooms({RoomStatus? status, RoomType? type}) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status.name;
      if (type != null) queryParams['type'] = type.name;

      final response = await _dio.get(
        '/rooms',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final List<dynamic> data = response.data is List
          ? response.data
          : response.data['data'] ?? response.data['rooms'] ?? [];

      return RoomMapper.fromJsonList(data);
    } on DioException catch (e) {
      throw _handleDioError(e, 'obtener habitaciones');
    }
  }

  @override
  Future<Room> getRoomById(String id) async {
    try {
      final response = await _dio.get('/rooms/$id');
      final data = response.data is Map
          ? response.data
          : response.data['data'];

      return RoomMapper.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e, 'obtener habitación');
    }
  }

  @override
  Future<Room> updateRoomStatus(String id, RoomStatus newStatus) async {
    try {
      final response = await _dio.patch(
        '/rooms/$id/status',
        data: {'status': newStatus.name},
      );
      final data = response.data is Map
          ? response.data
          : response.data['data'];

      return RoomMapper.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e, 'actualizar estado de habitación');
    }
  }

  /// Convierte un [DioException] en un mensaje de error legible
  Exception _handleDioError(DioException e, String action) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] ?? e.message ?? 'Error desconocido';

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Tiempo de espera agotado al $action. Verifica tu conexión.');
    }
    if (statusCode == 404) {
      return Exception('Recurso no encontrado al $action.');
    }
    if (statusCode == 401) {
      return Exception('No autorizado. Inicia sesión nuevamente.');
    }
    if (statusCode != null && statusCode >= 500) {
      return Exception('Error del servidor al $action. Intenta más tarde.');
    }
    return Exception('Error al $action: $message');
  }
}
