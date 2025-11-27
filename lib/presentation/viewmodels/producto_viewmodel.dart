import '../../domain/entities/producto_entity.dart';
import '../../domain/usecases/get_productos_usecase.dart';
import '../../domain/usecases/create_productos_usecase.dart';
import '../../domain/usecases/update_producto_usecase.dart';
import '../../domain/usecases/delete_producto_usecase.dart';
import 'base_viewmodel.dart';

class ProductoViewModel extends BaseViewModel {
  final GetProductosUseCase getUseCase;
  final CreateProductosUseCase createUseCase;
  final UpdateProductoUseCase updateUseCase;
  final DeleteProductoUseCase deleteUseCase;

  List<ProductoEntity> productos = [];

  ProductoViewModel(
    this.getUseCase,
    this.createUseCase,
    this.updateUseCase,
    this.deleteUseCase,
  );

  Future<void> cargarProductos() async {
    setLoading(true);
    try {
      productos = await getUseCase();
    } finally {
      setLoading(false);
    }
  }

  Future<ProductoEntity> crearProducto(ProductoEntity producto) async {
    setLoading(true);
    try {
      final created = await createUseCase(producto);
      productos.add(created);
      notifyListeners();
      return created;
    } finally {
      setLoading(false);
    }
  }

  Future<ProductoEntity> actualizarProducto(String id, ProductoEntity producto) async {
    setLoading(true);
    try {
      final updated = await updateUseCase(id, producto);
      final index = productos.indexWhere((p) => p.id == id);
      if (index != -1) {
        productos[index] = updated;
        notifyListeners();
      }
      return updated;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> eliminarProducto(String id) async {
    setLoading(true);
    try {
      final success = await deleteUseCase(id);
      if (success) {
        productos.removeWhere((p) => p.id == id);
        notifyListeners();
      }
      return success;
    } finally {
      setLoading(false);
    }
  }
}
