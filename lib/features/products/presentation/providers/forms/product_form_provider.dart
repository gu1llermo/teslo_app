import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_app/config/config.dart';

import '../../../../shared/shared.dart';
import '../../../domain/domain.dart';
import '../providers.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  final createUpdateCallback =
      ref.watch(productsProvider.notifier).createOrUpdateProduct;
  // final createUpdateCallback =
  //     ref.watch(productRepositoryProvider).createUpdateProduct;

  return ProductFormNotifier(
    product: product,
    onSubmitCallback: createUpdateCallback,
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  // Lo llama ProductLike, porque es algo que luce como un producto
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }) : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price.toString()),
          inStock: Stock.dirty(product.stock.toString()),
          tags: product.tags.join(', '),
          sizes: product.sizes,
          gender: product.gender,
          description: product.description,
          images: product.images,
        ));

  Future<bool> onFormSubmit() async {
    _touchEveryThing();
    if (!state.isFormValid) return false;
    if (onSubmitCallback == null) return false;
    // éste es el objeto que tenbemos que mandarle al backend
    final productLike = {
      'id': state.id == 'new' ? null : state.id,
      'title': state.title.value,
      'price': double.tryParse(state.price.value) ??
          0.0, // claro yo tengo todo protegido
      // para nunca me genere un error en la conversión, pero de todas formas
      // le coloco ésta protección
      'description': state.description,
      'slug': state.slug.value,
      'stock': int.tryParse(state.inStock.value) ?? 0,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(',').map((e) => e.trim()).toList(),
      'images': state.images
          .map((image) =>
              image.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList()
    };
    try {
      return await onSubmitCallback!(productLike);
      // si todo sale bien return true
    } catch (e) {
      return false;
    }
  }

  void _touchEveryThing() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value),
    ]));
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void onPriceChanged(String value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  void onStockChanged(String value) {
    state = state.copyWith(
        inStock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ]));
  }

  void onSizesChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty('0.0'),
    this.sizes = const [],
    this.gender = 'men',
    this.inStock = const Stock.dirty('0'),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });
  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        inStock: inStock ?? this.inStock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
