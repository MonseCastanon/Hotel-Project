import 'package:dio/dio.dart';
import 'package:hotel_app/domain/domain.dart';
import 'package:hotel_app/infrastructure/mappers/reservation_mapper.dart';

/// Implementación concreta de [ReservationsDataSource] usando Dio para llamadas al API REST.
class ReservationsDataSourceImpl implements ReservationsDataSource {
  final Dio _dio;

  ReservationsDataSourceImpl(this._dio);

  @override
  Future<List<Reservation>> getReservations({
    ReservationStatus? status,
    String? guestId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status.name;
      if (guestId != null) queryParams['guestId'] = guestId;

      final response = await _dio.get(
        '/reservations',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final List<dynamic> data = response.data is List
          ? response.data
          : response.data['data'] ?? response.data['reservations'] ?? [];

      return ReservationMapper.fromJsonList(data);
    } on DioException catch (e) {
      throw _handleDioError(e, 'obtener reservaciones');
    }
  }

  @override
  Future<Reservation> getReservationById(String id) async {
    try {
      final response = await _dio.get('/reservations/$id');
      final data = response.data is Map
          ? response.data
          : response.data['data'];

      return ReservationMapper.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e, 'obtener reservación');
    }
  }

  @override
  Future<Reservation> createReservation(CreateReservationParams params) async {
    try {
      final response = await _dio.post(
        '/reservations',
        data: {
          'roomId': params.roomId,
          'guestId': params.guestId,
          'guestName': params.guestName,
          'checkIn': params.checkIn.toIso8601String(),
          'checkOut': params.checkOut.toIso8601String(),
          if (params.notes != null) 'notes': params.notes,
        },
      );
      final data = response.data is Map
          ? response.data
          : response.data['data'];

      return ReservationMapper.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e, 'crear reservación');
    }
  }

  @override
  Future<Reservation> checkIn(String reservationId) async {
    try {
      final response =
          await _dio.post('/reservations/$reservationId/checkin');
      final data = response.data is Map
          ? response.data
          : response.data['data'];

      return ReservationMapper.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e, 'realizar check-in');
    }
  }

  @override
  Future<Reservation> checkOut(String reservationId) async {
    try {
      final response =
          await _dio.post('/reservations/$reservationId/checkout');
      final data = response.data is Map
          ? response.data
          : response.data['data'];

      return ReservationMapper.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e, 'realizar check-out');
    }
  }

  @override
  Future<Reservation> cancelReservation(String reservationId) async {
    try {
      final response =
          await _dio.delete('/reservations/$reservationId');
      final data = response.data is Map
          ? response.data
          : response.data['data'];

      return ReservationMapper.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e, 'cancelar reservación');
    }
  }

  /// Convierte un [DioException] en un mensaje de error legible
  Exception _handleDioError(DioException e, String action) {
    final statusCode = e.response?.statusCode;
    final message =
        e.response?.data?['message'] ?? e.message ?? 'Error desconocido';

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception(
          'Tiempo de espera agotado al $action. Verifica tu conexión.');
    }
    if (statusCode == 404) {
      return Exception('Recurso no encontrado al $action.');
    }
    if (statusCode == 401) {
      return Exception('No autorizado. Inicia sesión nuevamente.');
    }
    if (statusCode == 409) {
      return Exception(
          'Conflicto al $action. La habitación puede no estar disponible.');
    }
    if (statusCode != null && statusCode >= 500) {
      return Exception('Error del servidor al $action. Intenta más tarde.');
    }
    return Exception('Error al $action: $message');
  }
}
