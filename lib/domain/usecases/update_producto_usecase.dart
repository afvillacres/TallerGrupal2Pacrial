import '../entities/producto_entity.dart';
import '../../data/repositories/base_repository.dart';

class UpdateProductoUseCase {
  final BaseRepository repository;

  UpdateProductoUseCase(this.repository);

  // Actualiza un producto por id
  Future<ProductoEntity> call(String id, ProductoEntity producto) {
    return repository.updateProductos(id, producto);
  }
}