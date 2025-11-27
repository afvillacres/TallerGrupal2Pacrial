import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/presentation/viewmodels/producto_viewmodel.dart';
import '/domain/usecases/get_productos_usecase.dart';
import '/domain/usecases/create_productos_usecase.dart';
import '/domain/usecases/update_producto_usecase.dart';
import '/domain/usecases/delete_producto_usecase.dart';
import '/data/repositories/producto_repository_impl.dart';
import '/data/datasource/producto_api_datasource.dart';

import '/presentation/routes/app_routes.dart';

void main() {
  // Inyección de dependencias
  final dataSource = ProductoApiDataSource();
  final repo = ProductoRepositoryImpl(dataSource);

  // Usecases
  final getUseCase = GetProductosUseCase(repo);
  final createUseCase = CreateProductosUseCase(repo);
  final updateUseCase = UpdateProductoUseCase(repo);
  final deleteUseCase = DeleteProductoUseCase(repo);

  runApp(MyApp(
    getUseCase: getUseCase,
    createUseCase: createUseCase,
    updateUseCase: updateUseCase,
    deleteUseCase: deleteUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final GetProductosUseCase getUseCase;
  final CreateProductosUseCase createUseCase;
  final UpdateProductoUseCase updateUseCase;
  final DeleteProductoUseCase deleteUseCase;

  const MyApp({
    super.key,
    required this.getUseCase,
    required this.createUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductoViewModel(
            getUseCase,
            createUseCase,
            updateUseCase,
            deleteUseCase,
          )..cargarProductos(),
        ),
      ],
      child: MaterialApp(
        title: "Consumo APIs Locales",
        routes: AppRoutes.routes,
      ),
    );
  }
}
