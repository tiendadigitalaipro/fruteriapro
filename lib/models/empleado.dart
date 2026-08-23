class Empleado {
  final int id;
  final String nombre;
  final String cedula;
  final String cargo;
  final String pin;
  final String avatar;
  final bool activo;

  const Empleado({
    required this.id,
    required this.nombre,
    this.cedula = '',
    this.cargo = 'Vendedor',
    this.pin = '',
    this.avatar = '👨‍💼',
    this.activo = true,
  });

  Empleado copyWith({String? nombre, String? cedula, String? cargo, String? pin, String? avatar, bool? activo}) {
    return Empleado(
      id: id,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      cargo: cargo ?? this.cargo,
      pin: pin ?? this.pin,
      avatar: avatar ?? this.avatar,
      activo: activo ?? this.activo,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'cedula': cedula,
        'cargo': cargo,
        'pin': pin,
        'avatar': avatar,
        'activo': activo,
      };

  factory Empleado.fromJson(Map<String, dynamic> json) => Empleado(
        id: json['id'] as int,
        nombre: json['nombre'] ?? '',
        cedula: json['cedula'] ?? '',
        cargo: json['cargo'] ?? 'Vendedor',
        pin: json['pin'] ?? '',
        avatar: json['avatar'] ?? '👨‍💼',
        activo: json['activo'] ?? true,
      );
}
