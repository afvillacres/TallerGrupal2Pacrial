// Este Solo se encarga de enviar y extraer datos, no tiene nada de lógica
import '../models/producto_model.dart';

abstract class BaseDataSource{
  Future<List<ProductoModel>> fetchProductos();
  Future<ProductoModel> createProductos(Map<String, dynamic> data);
  Future<ProductoModel> updateProductos(String id, Map<String, dynamic> data);
  Future<bool> deleteProductos(String id);
}