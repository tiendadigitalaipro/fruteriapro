class Producto {
  final int id;
  final String nombre;
  final String emoji;
  final String categoria;
  final double precio;
  final double costo;
  final double stock;
  final double stockMin;
  final String unidad;

  const Producto({
    required this.id,
    required this.nombre,
    this.emoji = '🍎',
    this.categoria = '',
    required this.precio,
    this.costo = 0,
    this.stock = 0,
    this.stockMin = 5,
    this.unidad = 'kg',
  });

  bool get stockBajo => stock <= stockMin;

  Producto copyWith({
    String? nombre,
    String? emoji,
    String? categoria,
    double? precio,
    double? costo,
    double? stock,
    double? stockMin,
    String? unidad,
  }) {
    return Producto(
      id: id,
      nombre: nombre ?? this.nombre,
      emoji: emoji ?? this.emoji,
      categoria: categoria ?? this.categoria,
      precio: precio ?? this.precio,
      costo: costo ?? this.costo,
      stock: stock ?? this.stock,
      stockMin: stockMin ?? this.stockMin,
      unidad: unidad ?? this.unidad,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'emoji': emoji,
        'categoria': categoria,
        'precio': precio,
        'costo': costo,
        'stock': stock,
        'stockMin': stockMin,
        'unidad': unidad,
      };

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json['id'] as int,
        nombre: json['nombre'] ?? '',
        emoji: json['emoji'] ?? '🍎',
        categoria: json['categoria'] ?? '',
        precio: (json['precio'] as num?)?.toDouble() ?? 0,
        costo: (json['costo'] as num?)?.toDouble() ?? 0,
        stock: (json['stock'] as num?)?.toDouble() ?? 0,
        stockMin: (json['stockMin'] as num?)?.toDouble() ?? 5,
        unidad: json['unidad'] ?? 'kg',
      );
}
