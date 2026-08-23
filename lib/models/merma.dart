enum ModoMerma { inventario, libre }

/// Registro de pérdida/desperdicio — modo "inventario" descuenta stock de un
/// producto existente, modo "libre" registra pérdida de algo que nunca se
/// catalogó (fruta que se dañó antes de entrar al inventario).
class Merma {
  final String id;
  final DateTime fecha;
  final int? productoId;
  final String productoNombre;
  final String emoji;
  final double cantidad;
  final String unidad;
  final String motivo;
  final String notas;
  final double valorUnitario;
  final double valorTotal;
  final double tasa;
  final ModoMerma modo;

  const Merma({
    required this.id,
    required this.fecha,
    this.productoId,
    required this.productoNombre,
    this.emoji = '🥀',
    required this.cantidad,
    this.unidad = 'kg',
    required this.motivo,
    this.notas = '',
    required this.valorUnitario,
    required this.valorTotal,
    required this.tasa,
    required this.modo,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fecha': fecha.toIso8601String(),
        'productoId': productoId,
        'productoNombre': productoNombre,
        'emoji': emoji,
        'cantidad': cantidad,
        'unidad': unidad,
        'motivo': motivo,
        'notas': notas,
        'valorUnitario': valorUnitario,
        'valorTotal': valorTotal,
        'tasa': tasa,
        'modo': modo.name,
      };

  factory Merma.fromJson(Map<String, dynamic> json) => Merma(
        id: json['id'],
        fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
        productoId: json['productoId'] as int?,
        productoNombre: json['productoNombre'] ?? '',
        emoji: json['emoji'] ?? '🥀',
        cantidad: (json['cantidad'] as num?)?.toDouble() ?? 0,
        unidad: json['unidad'] ?? 'kg',
        motivo: json['motivo'] ?? '',
        notas: json['notas'] ?? '',
        valorUnitario: (json['valorUnitario'] as num?)?.toDouble() ?? 0,
        valorTotal: (json['valorTotal'] as num?)?.toDouble() ?? 0,
        tasa: (json['tasa'] as num?)?.toDouble() ?? 40,
        modo: ModoMerma.values.firstWhere((m) => m.name == json['modo'], orElse: () => ModoMerma.libre),
      );
}
