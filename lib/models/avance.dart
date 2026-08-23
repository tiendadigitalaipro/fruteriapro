enum EstadoAvance { pendiente, descontado }

/// Adelanto de efectivo a un empleado, a descontar de su próximo pago.
class Avance {
  final String id;
  final int empleadoId;
  final String empleadoNombre;
  final double montoUsd;
  final double montoBs;
  final DateTime fecha;
  final String motivo;
  final String notas;
  final EstadoAvance estado;

  const Avance({
    required this.id,
    required this.empleadoId,
    required this.empleadoNombre,
    required this.montoUsd,
    required this.montoBs,
    required this.fecha,
    this.motivo = '',
    this.notas = '',
    this.estado = EstadoAvance.pendiente,
  });

  Avance copyWith({EstadoAvance? estado}) => Avance(
        id: id,
        empleadoId: empleadoId,
        empleadoNombre: empleadoNombre,
        montoUsd: montoUsd,
        montoBs: montoBs,
        fecha: fecha,
        motivo: motivo,
        notas: notas,
        estado: estado ?? this.estado,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'empleadoId': empleadoId,
        'empleadoNombre': empleadoNombre,
        'montoUsd': montoUsd,
        'montoBs': montoBs,
        'fecha': fecha.toIso8601String(),
        'motivo': motivo,
        'notas': notas,
        'estado': estado.name,
      };

  factory Avance.fromJson(Map<String, dynamic> json) => Avance(
        id: json['id'],
        empleadoId: json['empleadoId'] as int,
        empleadoNombre: json['empleadoNombre'] ?? '',
        montoUsd: (json['montoUsd'] as num?)?.toDouble() ?? 0,
        montoBs: (json['montoBs'] as num?)?.toDouble() ?? 0,
        fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
        motivo: json['motivo'] ?? '',
        notas: json['notas'] ?? '',
        estado: EstadoAvance.values.firstWhere((e) => e.name == json['estado'], orElse: () => EstadoAvance.pendiente),
      );
}
