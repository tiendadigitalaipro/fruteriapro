import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/empleado.dart';
import '../../state/empleados_controller.dart';
import '../../theme/app_theme.dart';

const _cargos = ['Vendedor', 'Cajero', 'Administrador', 'Ayudante'];

class EmpleadosScreen extends StatelessWidget {
  const EmpleadosScreen({super.key});

  void _abrirFormulario(BuildContext context, {Empleado? empleado}) {
    final nombreCtrl = TextEditingController(text: empleado?.nombre ?? '');
    final cedulaCtrl = TextEditingController(text: empleado?.cedula ?? '');
    final pinCtrl = TextEditingController(text: empleado?.pin ?? '');
    String cargo = empleado?.cargo ?? _cargos.first;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(empleado != null ? 'Editar empleado' : 'Nuevo empleado', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                TextField(controller: nombreCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Nombre *')),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(controller: cedulaCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Cédula'))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(controller: pinCtrl, keyboardType: TextInputType.number, maxLength: 4, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'PIN (4 dígitos)')),
                  ),
                ]),
                DropdownButtonFormField<String>(
                  initialValue: cargo,
                  dropdownColor: AppColors.surfaceLight,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Cargo'),
                  items: _cargos.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setSt(() => cargo = v ?? cargo),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (nombreCtrl.text.trim().isEmpty) return;
                    if (pinCtrl.text.isNotEmpty && pinCtrl.text.length != 4) {
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('El PIN debe tener 4 dígitos'), backgroundColor: Colors.redAccent));
                      return;
                    }
                    context.read<EmpleadosController>().guardar(Empleado(id: empleado?.id ?? 0, nombre: nombreCtrl.text.trim(), cedula: cedulaCtrl.text.trim(), cargo: cargo, pin: pinCtrl.text.trim()));
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text(empleado != null ? 'Guardar cambios' : 'Agregar empleado'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final empleados = context.watch<EmpleadosController>().empleados;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(heroTag: 'emp_fab', backgroundColor: AppColors.orange, foregroundColor: Colors.black, onPressed: () => _abrirFormulario(context), child: const Icon(Icons.add)),
      body: empleados.isEmpty
          ? Center(child: Text('No hay empleados registrados.', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: empleados.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final e = empleados[i];
                return Card(
                  child: ListTile(
                    onTap: () => _abrirFormulario(context, empleado: e),
                    leading: CircleAvatar(backgroundColor: AppColors.orange.withValues(alpha: 0.15), child: Text(e.avatar, style: const TextStyle(fontSize: 16))),
                    title: Text(e.nombre, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(e.cargo, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    trailing: Switch(value: e.activo, activeThumbColor: AppColors.orange, onChanged: (_) => context.read<EmpleadosController>().alternarActivo(e.id)),
                  ),
                );
              },
            ),
    );
  }
}
