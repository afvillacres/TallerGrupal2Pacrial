//Consume la api con http + Future
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_datasource.dart';
import '../models/producto_model.dart';

class ProductoApiDataSource implements BaseDataSource {
  final String baseURL = "http://localhost:3000/api/productos";
/*Obtener*/
  @override
  Future<List<ProductoModel>> fetchProductos() async {
    final uri = Uri.parse(baseURL);
    final resp = await http.get(uri);

    if(resp.statusCode != 200){
      throw Exception("Error al obtener datos de la api");
    }

    //decodificación JSON
    final List data = json.decode(resp.body);

    //mapear el JSON a modelo
    return data.map((item) => ProductoModel.fromJson(item)).toList();

  }
/*Crear*/
  @override
  Future<ProductoModel> createProductos(Map<String, dynamic> data) async {
    final resp = await http.post(
      Uri.parse(baseURL),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception("Error al crear producto");
    }

    //decodificación JSON (esperamos un objeto)
    final Map<String, dynamic> jsonData = json.decode(resp.body);

    //mapear el JSON a modelo
    return ProductoModel.fromJson(jsonData);
  }

  @override
  Future<bool> deleteProductos(String id) async {
    final resp = await http.delete(Uri.parse("$baseURL/$id"));
    return resp.statusCode >= 200 && resp.statusCode < 300;
  }

  @override
  Future<ProductoModel> updateProductos(String id, Map<String, dynamic> data) async {
    final resp = await http.put(
      Uri.parse("$baseURL/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception("Error al actualizar producto");
    }

    //decodificación JSON (esperamos un objeto)
    final Map<String, dynamic> jsonData = json.decode(resp.body);

    //mapear el JSON a modelo
    return ProductoModel.fromJson(jsonData);
  }
}
