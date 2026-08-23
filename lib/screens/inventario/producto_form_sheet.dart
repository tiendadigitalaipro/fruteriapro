import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../state/productos_controller.dart';
import '../../theme/app_theme.dart';

class ProductoFormSheet extends StatefulWidget {
  final Producto? producto;
  const ProductoFormSheet({super.key, this.producto});

  @override
  State<ProductoFormSheet> createState() => _ProductoFormSheetState();
}

class _ProductoFormSheetState extends State<ProductoFormSheet> {
  late final _emojiCtrl = TextEditingController(text: widget.producto?.emoji ?? '🍎');
  late final _nombreCtrl = TextEditingController(text: widget.producto?.nombre ?? '');
  late final _catCtrl = TextEditingController(text: widget.producto?.categoria ?? '');
  late final _precioCtrl = TextEditingController(text: widget.producto?.precio.toString() ?? '');
  late final _costoCtrl = TextEditingController(text: widget.producto?.costo.toString() ?? '0');
  late final _stockCtrl = TextEditingController(text: widget.producto?.stock.toString() ?? '0');
  late final _stockMinCtrl = TextEditingController(text: widget.producto?.stockMin.toString() ?? '5');
  late final _unidadCtrl = TextEditingController(text: widget.producto?.unidad ?? 'kg');

  void _guardar() {
    if (_nombreCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El nombre es obligatorio'), backgroundColor: Colors.redAccent));
      return;
    }
    final controller = context.read<ProductosController>();
    final datos = Producto(
      id: widget.producto?.id ?? 0,
      nombre: _nombreCtrl.text.trim(),
      emoji: _emojiCtrl.text.trim().isEmpty ? '🍎' : _emojiCtrl.text.trim(),
      categoria: _catCtrl.text.trim(),
      precio: double.tryParse(_precioCtrl.text) ?? 0,
      costo: double.tryParse(_costoCtrl.text) ?? 0,
      stock: double.tryParse(_stockCtrl.text) ?? 0,
      stockMin: double.tryParse(_stockMinCtrl.text) ?? 5,
      unidad: _unidadCtrl.text.trim().isEmpty ? 'kg' : _unidadCtrl.text.trim(),
    );
    if (widget.producto != null) {
      controller.guardar(datos);
    } else {
      controller.crear(datos);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.producto != null;
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16 + MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(editando ? 'Editar producto' : 'Nuevo producto', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Row(children: [
                SizedBox(width: 70, child: TextField(controller: _emojiCtrl, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20), decoration: const InputDecoration(labelText: 'Emoji'))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _nombreCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Nombre *'))),
              ]),
              const SizedBox(height: 12),
              TextField(controller: _catCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Categoría')),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextField(controller: _costoCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Costo'))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _precioCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Precio venta *'))),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextField(controller: _stockCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Stock'))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _stockMinCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Stock mínimo'))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _unidadCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Unidad'))),
              ]),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: Text(editando ? 'Guardar cambios' : 'Agregar producto', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
