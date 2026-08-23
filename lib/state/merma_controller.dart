import 'package:flutter/material.dart';
import '../data/app_database.dart';
import '../models/merma.dart';
import '../models/producto.dart';
import 'productos_controller.dart';

class MermaController extends ChangeNotifier {
  final List<Merma> mermas = [];

  Future<void> cargar() async {
    await AppDatabase.init();
    final json = AppDatabase.getJson('merma') as List?;
    mermas
      ..clear()
      ..addAll((json ?? []).map((m) => Merma.fromJson(m)));
    notifyListeners();
  }

  Future<void> _guardar() async {
    await AppDatabase.setJson('merma', mermas.map((m) => m.toJson()).toList());
  }

  Future<void> registrarDesdeInventario({
    required ProductosController productos,
    required Producto producto,
    required double cantidad,
    required String motivo,
    String notas = '',
    required double tasa,
  }) async {
    final valor = producto.precio * cantidad;
    mermas.insert(
      0,
      Merma(
        id: 'm${DateTime.now().millisecondsSinceEpoch}',
        fecha: DateTime.now(),
        productoId: producto.id,
        productoNombre: producto.nombre,
        emoji: producto.emoji,
        cantidad: cantidad,
        unidad: producto.unidad,
        motivo: motivo,
        notas: notas,
        valorUnitario: producto.precio,
        valorTotal: valor,
        tasa: tasa,
        modo: ModoMerma.inventario,
      ),
    );
    await productos.ajustarStock(producto.id, -cantidad);
    await _guardar();
    notifyListeners();
  }

  Future<void> registrarLibre({
    required String nombre,
    required String emoji,
    required double cantidad,
    required String unidad,
    required double precioUnitario,
    required String motivo,
    String notas = '',
    required double tasa,
  }) async {
    mermas.insert(
      0,
      Merma(
        id: 'm${DateTime.now().millisecondsSinceEpoch}',
        fecha: DateTime.now(),
        productoId: null,
        productoNombre: nombre,
        emoji: emoji,
        cantidad: cantidad,
        unidad: unidad,
        motivo: motivo,
        notas: notas,
        valorUnitario: precioUnitario,
        valorTotal: precioUnitario * cantidad,
        tasa: tasa,
        modo: ModoMerma.libre,
      ),
    );
    await _guardar();
    notifyListeners();
  }
}
