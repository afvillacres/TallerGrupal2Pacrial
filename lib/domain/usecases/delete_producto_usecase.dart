import '../../data/repositories/base_repository.dart';

class DeleteProductoUseCase {
	final BaseRepository repository;

	DeleteProductoUseCase(this.repository);

	Future<bool> call(String id) {
		return repository.deleteProductos(id);
	}
}
