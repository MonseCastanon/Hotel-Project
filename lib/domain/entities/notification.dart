/// Tipos de notificación disponibles en el sistema
enum NotificationType {
  task,
  reservation,
  alert,
  system;

  String get label => switch (this) {
        NotificationType.task => 'Tarea',
        NotificationType.reservation => 'Reservación',
        NotificationType.alert => 'Alerta',
        NotificationType.system => 'Sistema',
      };
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedId;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.relatedId,
  });

  /// Retorna true si la notificación no ha sido leída
  bool get isUnread => !isRead;

  /// Crea una copia de la entidad con los campos modificados
  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    String? relatedId,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      relatedId: relatedId ?? this.relatedId,
    );
  }

  @override
  String toString() =>
      'AppNotification(id: $id, title: $title, type: ${type.label}, isRead: $isRead)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppNotification && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
