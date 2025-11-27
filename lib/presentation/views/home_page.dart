import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../../domain/entities/producto_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nombreCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _categoriaCtrl = TextEditingController();

  String? _editingId;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    _categoriaCtrl.dispose();
    super.dispose();
  }

  void _clearForm() {
    _editingId = null;
    _nombreCtrl.clear();
    _precioCtrl.clear();
    _stockCtrl.clear();
    _categoriaCtrl.clear();
    setState(() {});
  }

  Future<void> _saveProducto(ProductoViewModel vm) async {
    final nombre = _nombreCtrl.text.trim();
    final precio = double.tryParse(_precioCtrl.text) ?? 0.0;
    final stock = int.tryParse(_stockCtrl.text) ?? 0;
    final categoria = _categoriaCtrl.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nombre requerido')));
      return;
    }

    final producto = ProductoEntity(
      id: _editingId ?? '',
      nombre: nombre,
      precio: precio,
      stock: stock,
      categoria: categoria,
    );

    try {
      if (_editingId == null) {
        await vm.crearProducto(producto);
      } else {
        await vm.actualizarProducto(_editingId!, producto);
      }
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _onEdit(ProductoViewModel vm, ProductoEntity p) async {
    _editingId = p.id;
    _nombreCtrl.text = p.nombre;
    _precioCtrl.text = p.precio.toString();
    _stockCtrl.text = p.stock.toString();
    _categoriaCtrl.text = p.categoria;
    setState(() {});
  }

  Future<void> _onDelete(ProductoViewModel vm, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Eliminar este producto?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (ok == true) {
      try {
        await vm.eliminarProducto(id);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductoViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(controller: _nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
                          TextField(controller: _precioCtrl, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
                          TextField(controller: _stockCtrl, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
                          TextField(controller: _categoriaCtrl, decoration: const InputDecoration(labelText: 'Categoria')),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _saveProducto(vm),
                                  child: Text(_editingId == null ? 'Crear' : 'Actualizar'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (_editingId != null)
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _clearForm,
                                    child: const Text('Cancelar'),
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.productos.length,
                    itemBuilder: (_, i) {
                      final p = vm.productos[i];
                      return ListTile(
                        title: Text(p.nombre),
                        subtitle: Text('Precio: \$${p.precio} | Stock: ${p.stock} | Cat: ${p.categoria}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _onEdit(vm, p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _onDelete(vm, p.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
