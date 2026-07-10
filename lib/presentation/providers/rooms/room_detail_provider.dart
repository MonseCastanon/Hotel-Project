import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/domain/domain.dart';
import 'package:hotel_app/presentation/providers/rooms/rooms_provider.dart';

// ───────────────────────────── Estado ────────────────────────────────────────

class RoomDetailState {
  final Room? room;
  final bool isLoading;
  final String? errorMessage;

  const RoomDetailState({
    this.room,
    this.isLoading = false,
    this.errorMessage,
  });

  RoomDetailState copyWith({
    Room? room,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RoomDetailState(
      room: room ?? this.room,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

// ─────────────────────────── Notifier (Riverpod 3 family) ────────────────────

class RoomDetailNotifier extends Notifier<RoomDetailState> {
  late final String _roomId;

  @override
  RoomDetailState build() => const RoomDetailState();

  RoomsRepository get _repository => ref.read(roomsRepositoryProvider);

  /// Carga el detalle de una habitación por su ID
  Future<void> loadRoom(String id) async {
    _roomId = id;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final room = await _repository.getRoomById(id);
      state = state.copyWith(room: room, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Reintenta la carga del último roomId
  Future<void> retry() => loadRoom(_roomId);
}

// ─────────────────────────── Provider ────────────────────────────────────────

/// Provider del detalle de habitación — se inicializa con [loadRoom] desde la pantalla
final roomDetailProvider =
    NotifierProvider<RoomDetailNotifier, RoomDetailState>(
  RoomDetailNotifier.new,
);
