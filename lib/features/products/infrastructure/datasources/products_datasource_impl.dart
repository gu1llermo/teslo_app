import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/products/domain/domain.dart';

import '../errors/products_error.dart';
import '../mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accesToken;
  ProductsDatasourceImpl({required this.accesToken})
      : dio = Dio(BaseOptions(baseUrl: Environment.apiUrl, headers: {
          'Authorization': 'Bearer $accesToken',
        }));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      // si es null es porque quiere crer un producto nuevo
      // si no es null es porque quiere actualizar el producto
      final String method = productId == null ? 'POST' : 'PATCH';
      final String url =
          productId == null ? '/products' : '/products/$productId';
      productLike.remove('id');
      final response = await dio.request(
        url,
        data: productLike,
        options: Options(method: method),
      );
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      // todo: manejar las excepciones
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      // si entra aquí siempre se tiene a e.response
      if (e.response!.statusCode == 404) throw ProductNotFound();
      // sino lanzamos ésta excepción y según Fernando esto vá en cascada
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    // legalmente aquí hay que manejar un try catch en ésta petición y en todas
    final response = await dio.get<List>(
      '/products',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );
    final List<Product> products = [];
    for (final jsonProduct in response.data ?? []) {
      // aquí vá el mapper
      final product = ProductMapper.jsonToEntity(jsonProduct);
      products.add(product);
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
