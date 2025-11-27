import '../../domain/entities/producto_entity.dart';

abstract class BaseRepository {
  Future<List<ProductoEntity>> getProductos();

  Future<ProductoEntity>createProductos(ProductoEntity p);
  Future<ProductoEntity>updateProductos(String id, ProductoEntity p);
  Future<bool>deleteProductos(String id);
}