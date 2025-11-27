import '../../domain/entities/producto_entity.dart';
import '../datasource/base_datasource.dart';
import '../models/producto_model.dart';
import 'base_repository.dart';

class ProductoRepositoryImpl implements BaseRepository{
  final BaseDataSource ds;

  ProductoRepositoryImpl(this.ds);

  @override
  Future<List<ProductoEntity>> getProductos() async {
    final productos = await ds.fetchProductos();
    return productos.map<ProductoEntity>((p) => p as ProductoEntity).toList();
  }


  @override
  Future<ProductoEntity> createProductos(ProductoEntity p) async {
    final created = await ds.createProductos({
      'id': p.id,
      'nombre': p.nombre,
      'precio': p.precio,
      'stock': p.stock,
      'categoria': p.categoria,
    });

    return created;
  }

  @override
  Future<ProductoEntity> updateProductos(String id, ProductoEntity p) async {
    final updated = await ds.updateProductos(id, {
      'id': p.id,
      'nombre': p.nombre,
      'precio': p.precio,
      'stock': p.stock,
      'categoria': p.categoria,
    });

    return updated;
  }

  @override
  Future<bool> deleteProductos(String id) async {
    return await ds.deleteProductos(id);
  }
}