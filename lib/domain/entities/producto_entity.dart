// Es el primer paso, en Domain/Entities definir la entidad
class ProductoEntity {
  //Definición de atributos según el diseño para mongoDB
  final String id;
  final String nombre;
  final double precio;
  final int stock;
  final String categoria;

  //Constructor con atributos para su inicialización required
  ProductoEntity({required this.id, required this.nombre, required this.precio, required this.stock, required this.categoria});
}