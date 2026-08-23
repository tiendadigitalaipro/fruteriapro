import 'package:flutter/material.dart';
import '../data/app_database.dart';
import '../models/empleado.dart';

class EmpleadosController extends ChangeNotifier {
  final List<Empleado> empleados = [];

  Future<void> cargar() async {
    await AppDatabase.init();
    final json = AppDatabase.getJson('empleados') as List?;
    empleados
      ..clear()
      ..addAll((json ?? []).map((e) => Empleado.fromJson(e)));
    notifyListeners();
  }

  Future<void> _guardar() async {
    await AppDatabase.setJson('empleados', empleados.map((e) => e.toJson()).toList());
  }

  int _siguienteId() => empleados.isEmpty ? 1 : (empleados.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);

  Future<void> guardar(Empleado empleado) async {
    final i = empleados.indexWhere((e) => e.id == empleado.id);
    if (i >= 0) {
      empleados[i] = empleado;
    } else {
      empleados.add(Empleado(
        id: _siguienteId(),
        nombre: empleado.nombre,
        cedula: empleado.cedula,
        cargo: empleado.cargo,
        pin: empleado.pin,
        avatar: empleado.avatar,
      ));
    }
    await _guardar();
    notifyListeners();
  }

  Future<void> eliminar(int id) async {
    empleados.removeWhere((e) => e.id == id);
    await _guardar();
    notifyListeners();
  }

  Future<void> alternarActivo(int id) async {
    final i = empleados.indexWhere((e) => e.id == id);
    if (i < 0) return;
    empleados[i] = empleados[i].copyWith(activo: !empleados[i].activo);
    await _guardar();
    notifyListeners();
  }
}
