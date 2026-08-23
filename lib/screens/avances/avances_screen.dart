import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/avance.dart';
import '../../state/avances_controller.dart';
import '../../state/configuracion_controller.dart';
import '../../state/empleados_controller.dart';
import '../../theme/app_theme.dart';
import '../../utils/currency.dart';

class AvancesScreen extends StatefulWidget {
  const AvancesScreen({super.key});

  @override
  State<AvancesScreen> createState() => _AvancesScreenState();
}

class _AvancesScreenState extends State<AvancesScreen> {
  int? _empleadoId;
  final _montoCtrl = TextEditingController();
  final _motivoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final empleados = context.watch<EmpleadosController>().empleados;
    final avances = context.watch<AvancesController>().avances;
    final tasa = context.watch<ConfiguracionController>().config.tasa;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<int>(
            initialValue: _empleadoId,
            dropdownColor: AppColors.surfaceLight,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Empleado *'),
            items: empleados.map((e) => DropdownMenuItem(value: e.id, child: Text(e.nombre))).toList(),
            onChanged: (v) => setState(() => _empleadoId = v),
          ),
          const SizedBox(height: 12),
          TextField(controller: _montoCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Monto (\$) *')),
          const SizedBox(height: 12),
          TextField(controller: _motivoCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Motivo')),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final monto = double.tryParse(_montoCtrl.text) ?? 0;
              if (_empleadoId == null || monto <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa empleado y monto'), backgroundColor: Colors.redAccent));
                return;
              }
              final emp = empleados.firstWhere((e) => e.id == _empleadoId);
              await context.read<AvancesController>().registrar(empleadoId: emp.id, empleadoNombre: emp.nombre, montoUsd: monto, tasa: tasa, motivo: _motivoCtrl.text.trim());
              _montoCtrl.clear();
              _motivoCtrl.clear();
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('💰 Avance registrado'), backgroundColor: Colors.green));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Registrar avance'),
          ),
          const SizedBox(height: 20),
          const Text('Historial de avances', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (avances.isEmpty)
            Padding(padding: const EdgeInsets.symmetric(vertical: 30), child: Center(child: Text('Sin avances registrados', style: TextStyle(color: Colors.white.withValues(alpha: 0.4)))))
          else
            ...avances.map((a) => Card(
                  child: ListTile(
                    title: Text('${a.empleadoNombre} · ${formatMoney(a.montoUsd)}', style: const TextStyle(color: Colors.white)),
                    subtitle: Text('${a.motivo.isNotEmpty ? '${a.motivo} · ' : ''}${a.fecha.day}/${a.fecha.month}/${a.fecha.year}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    trailing: a.estado == EstadoAvance.pendiente
                        ? TextButton(onPressed: () => context.read<AvancesController>().marcarDescontado(a.id), child: const Text('Marcar pagado', style: TextStyle(color: AppColors.orange, fontSize: 11)))
                        : const Text('Descontado', style: TextStyle(color: Colors.greenAccent, fontSize: 11)),
                  ),
                )),
        ],
      ),
    );
  }
}
