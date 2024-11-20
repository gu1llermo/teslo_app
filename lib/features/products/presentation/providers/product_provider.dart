import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import 'providers.dart';

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productRepository = ref.watch(productRepositoryProvider);
  return ProductNotifier(
      productId: productId, productRepository: productRepository);
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productRepository;

  ProductNotifier({required String productId, required this.productRepository})
      : super(ProductState(id: productId)) {
    loadProduct(); // desde aquí mismo del constructor llama al loadProduct
  }

  Product _newEmptyProduct() => Product(
        id: 'new',
        title: '',
        price: 0.0,
        description: '',
        slug: '',
        stock: 0,
        sizes: [],
        gender: 'men',
        tags: [],
        images: [],
      );

  Future<void> loadProduct() async {
    try {
      late Product product;
      if (state.id == 'new') {
        product = _newEmptyProduct();
      } else {
        product = await productRepository.getProductById(state.id);
      }
      state = state.copyWith(
        isLoading: false,
        product: product,
      );
    } catch (e) {
      // 404 product not found
      debugPrint(e.toString());
    }
    // no hace falta resetear el estado porque todo eso se hace automaticamente
    // con el dispose
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    // cuando se crea el estado del producto, vamos a suponer
    // que se está buscando, por eso colocamos isLoading en true al principio
    this.isLoading = true,
    this.isSaving = false,
  });
  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
