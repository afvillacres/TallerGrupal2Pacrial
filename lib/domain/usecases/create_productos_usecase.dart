import '../entities/producto_entity.dart';
import '../../data/repositories/base_repository.dart';

class CreateProductosUseCase {
  final BaseRepository repository;

  CreateProductosUseCase(this.repository);

  //Mediante Future traemos el producto entity
  Future<ProductoEntity> call(ProductoEntity producto){
    return repository.createProductos(producto);
  }
}

