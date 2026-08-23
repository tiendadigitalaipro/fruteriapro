import 'package:flutter/material.dart';
import '../data/app_database.dart';
import '../models/avance.dart';

class AvancesController extends ChangeNotifier {
  final List<Avance> avances = [];

  Future<void> cargar() async {
    await AppDatabase.init();
    final json = AppDatabase.getJson('avances') as List?;
    avances
      ..clear()
      ..addAll((json ?? []).map((a) => Avance.fromJson(a)));
    notifyListeners();
  }

  Future<void> _guardar() async {
    await AppDatabase.setJson('avances', avances.map((a) => a.toJson()).toList());
  }

  Future<void> registrar({
    required int empleadoId,
    required String empleadoNombre,
    required double montoUsd,
    required double tasa,
    String motivo = '',
    String notas = '',
  }) async {
    avances.insert(
      0,
      Avance(
        id: 'av${DateTime.now().millisecondsSinceEpoch}',
        empleadoId: empleadoId,
        empleadoNombre: empleadoNombre,
        montoUsd: montoUsd,
        montoBs: montoUsd * tasa,
        fecha: DateTime.now(),
        motivo: motivo,
        notas: notas,
      ),
    );
    await _guardar();
    notifyListeners();
  }

  Future<void> marcarDescontado(String id) async {
    final i = avances.indexWhere((a) => a.id == id);
    if (i < 0) return;
    avances[i] = avances[i].copyWith(estado: EstadoAvance.descontado);
    await _guardar();
    notifyListeners();
  }

  Future<void> eliminar(String id) async {
    avances.removeWhere((a) => a.id == id);
    await _guardar();
    notifyListeners();
  }
}
