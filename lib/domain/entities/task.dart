/// Estados posibles de una tarea
enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled;

  String get label => switch (this) {
        TaskStatus.pending => 'Pendiente',
        TaskStatus.inProgress => 'En progreso',
        TaskStatus.completed => 'Completada',
        TaskStatus.cancelled => 'Cancelada',
      };
}

/// Niveles de prioridad para una tarea
enum TaskPriority {
  low,
  medium,
  high,
  urgent;

  String get label => switch (this) {
        TaskPriority.low => 'Baja',
        TaskPriority.medium => 'Media',
        TaskPriority.high => 'Alta',
        TaskPriority.urgent => 'Urgente',
      };
}

class Task {
  final String id;
  final String title;
  final String description;
  final String? roomId;
  final String? assignedTo;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.roomId,
    this.assignedTo,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.completedAt,
  });

  /// Retorna true si la tarea está pendiente o en progreso
  bool get isActive =>
      status == TaskStatus.pending || status == TaskStatus.inProgress;

  /// Retorna true si la tarea es urgente o de alta prioridad
  bool get isHighPriority =>
      priority == TaskPriority.high || priority == TaskPriority.urgent;

  /// Crea una copia de la entidad con los campos modificados
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? roomId,
    String? assignedTo,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      roomId: roomId ?? this.roomId,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() =>
      'Task(id: $id, title: $title, status: ${status.label}, priority: ${priority.label})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Task && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
