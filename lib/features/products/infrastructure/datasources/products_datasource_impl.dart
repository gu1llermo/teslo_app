import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/products/domain/domain.dart';

import '../mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accesToken;
  ProductsDatasourceImpl({required this.accesToken})
      : dio = Dio(BaseOptions(baseUrl: Environment.apiUrl, headers: {
          'Authorization': 'Bearer $accesToken',
        }));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
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
