import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/presentation/providers/providers.dart';
import 'package:teslo_app/features/products/infrastructure/infrastructure.dart';
import '../../domain/domain.dart';

final productRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accesToken = ref.watch(authProvider).user?.token ?? '';
  final datasource = ProductsDatasourceImpl(accesToken: accesToken);
  return ProductsRepositoryImpl(datasource);
});
