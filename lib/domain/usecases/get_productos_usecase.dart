// Es el segundo paso, definir el caso de uso
//Lo que se va a hacer en este archivo es obtener la lista de todos los productos desde la api
import '../entities/producto_entity.dart';
import '../../data/repositories/base_repository.dart';

class GetProductosUseCase {
  final BaseRepository repository;

  GetProductosUseCase(this.repository);

  //Mediante Future traemos el producto entity
  Future<List<ProductoEntity>> call(){
    return repository.getProductos();
  }
}

