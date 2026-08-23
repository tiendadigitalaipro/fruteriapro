import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/configuracion_controller.dart';
import '../../state/merma_controller.dart';
import '../../state/productos_controller.dart';
import '../../theme/app_theme.dart';
import '../../utils/currency.dart';

class MermaScreen extends StatefulWidget {
  const MermaScreen({super.key});

  @override
  State<MermaScreen> createState() => _MermaScreenState();
}

class _MermaScreenState extends State<MermaScreen> {
  bool _modoInventario = true;
  int? _productoId;
  final _cantidadCtrl = TextEditingController();
  final _libreNombreCtrl = TextEditingController();
  final _librePrecioCtrl = TextEditingController();
  final _motivoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productos = context.watch<ProductosController>().productos;
    final mermas = context.watch<MermaController>().mermas;
    final tasa = context.watch<ConfiguracionController>().config.tasa;
    final totalMes = mermas.where((m) => m.fecha.month == DateTime.now().month).fold<double>(0, (s, m) => s + m.valorTotal);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: AppColors.surfaceLight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Merma del mes', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
                Text(formatMoney(totalMes), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [ButtonSegment(value: true, label: Text('Del inventario')), ButtonSegment(value: false, label: Text('Producto libre'))],
            selected: {_modoInventario},
            onSelectionChanged: (s) => setState(() => _modoInventario = s.first),
          ),
          const SizedBox(height: 16),
          if (_modoInventario) ...[
            DropdownButtonFormField<int>(
              initialValue: _productoId,
              dropdownColor: AppColors.surfaceLight,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Producto *'),
              items: productos.map((p) => DropdownMenuItem(value: p.id, child: Text('${p.emoji} ${p.nombre} (${p.stock.toStringAsFixed(0)} ${p.unidad})'))).toList(),
              onChanged: (v) => setState(() => _productoId = v),
            ),
          ] else ...[
            TextField(controller: _libreNombreCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Nombre del producto *')),
            const SizedBox(height: 12),
            TextField(controller: _librePrecioCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Precio unitario (\$) *')),
          ],
          const SizedBox(height: 12),
          TextField(controller: _cantidadCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Cantidad *')),
          const SizedBox(height: 12),
          TextField(controller: _motivoCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Motivo *', hintText: 'Dañado, vencido, etc.')),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final cantidad = double.tryParse(_cantidadCtrl.text) ?? 0;
              final motivo = _motivoCtrl.text.trim();
              if (cantidad <= 0 || motivo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa cantidad y motivo'), backgroundColor: Colors.redAccent));
                return;
              }
              final mermaCtrl = context.read<MermaController>();
              if (_modoInventario) {
                final prod = productos.where((p) => p.id == _productoId);
                if (prod.isEmpty) return;
                await mermaCtrl.registrarDesdeInventario(productos: context.read<ProductosController>(), producto: prod.first, cantidad: cantidad, motivo: motivo, tasa: tasa);
              } else {
                final precio = double.tryParse(_librePrecioCtrl.text) ?? 0;
                if (_libreNombreCtrl.text.trim().isEmpty || precio <= 0) return;
                await mermaCtrl.registrarLibre(nombre: _libreNombreCtrl.text.trim(), emoji: '🥀', cantidad: cantidad, unidad: 'kg', precioUnitario: precio, motivo: motivo, tasa: tasa);
              }
              _cantidadCtrl.clear();
              _libreNombreCtrl.clear();
              _librePrecioCtrl.clear();
              _motivoCtrl.clear();
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🥀 Merma registrada'), backgroundColor: Colors.green));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Registrar merma'),
          ),
          const SizedBox(height: 20),
          const Text('Historial', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...mermas.map((m) => Card(
                child: ListTile(
                  leading: Text(m.emoji, style: const TextStyle(fontSize: 18)),
                  title: Text(m.productoNombre, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${m.cantidad.toStringAsFixed(1)} ${m.unidad} · ${m.motivo}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  trailing: Text(formatMoney(m.valorTotal), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ),
              )),
        ],
      ),
    );
  }
}
