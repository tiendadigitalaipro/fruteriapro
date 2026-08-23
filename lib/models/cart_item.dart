class CartItem {
  final int productId;
  final String nombre;
  final String emoji;
  final double precio;
  final double qty;

  const CartItem({
    required this.productId,
    required this.nombre,
    required this.emoji,
    required this.precio,
    this.qty = 1,
  });

  double get total => precio * qty;

  CartItem copyWith({double? qty}) => CartItem(
        productId: productId,
        nombre: nombre,
        emoji: emoji,
        precio: precio,
        qty: qty ?? this.qty,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'nombre': nombre,
        'emoji': emoji,
        'precio': precio,
        'qty': qty,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] as int,
        nombre: json['nombre'] ?? '',
        emoji: json['emoji'] ?? '🍎',
        precio: (json['precio'] as num?)?.toDouble() ?? 0,
        qty: (json['qty'] as num?)?.toDouble() ?? 1,
      );
}
