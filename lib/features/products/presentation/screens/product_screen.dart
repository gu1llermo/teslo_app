import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/features/products/presentation/providers/providers.dart';

import '../../../shared/widgets/widgets.dart';
import '../../domain/domain.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key, required this.productId});
  final String productId;

  // void showSnackbar(
  //   BuildContext context,
  // ) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text('Producto actualizado')));
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));
    //debugPrint(productId);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editar Producto'),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_outlined))
          ],
        ),
        body: productState.isLoading
            ? FullScreenLoader()
            : _ProductView(
                product: productState.product!,
                productId: productId,
              ),
        // floatingActionButton: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     FloatingActionButton(
        //       heroTag: 'save',
        //       onPressed: () {
        //         if (productState.product == null) return;
        //         ref
        //             .read(productFormProvider(productState.product!).notifier)
        //             .onFormSubmit()
        //             .then(
        //           (value) {
        //             // en realidad me gusta enterarme qué pasó
        //             if (!value || !context.mounted) {
        //               return; // no me gusta que no haga nada
        //             }
        //             // Hago la validación del mounted por seguridad
        //             // para evitar un posible fallo al usar el context
        //             showCenterOverlay(context,
        //                 message: 'Product has been updated',
        //                 icon: Icon(
        //                   Icons.check_circle,
        //                   color: Colors.green,
        //                   size: 60,
        //                 ));
        //           },
        //         );
        //       },
        //       child: Icon(Icons.save_as_outlined),
        //     ),
        //     const SizedBox(height: 10),
        //     FloatingActionButton(
        //       heroTag: 'delete',
        //       onPressed: () {
        //         if (productState.product == null) return;
        //         ref
        //             .read(productFormProvider(productState.product!).notifier)
        //             .deleteProduct(productId)
        //             .then(
        //           (value) {
        //             // en realidad me gusta enterarme qué pasó
        //             if (!value || !context.mounted) {
        //               return; // no me gusta que no haga nada
        //             }
        //             // Hago la validación del mounted por seguridad
        //             // para evitar un posible fallo al usar el context

        //             showCenterOverlay(context,
        //                 message: 'Product successfully removed!',
        //                 icon: Icon(
        //                   Icons.check_circle,
        //                   color: Colors.red,
        //                   size: 60,
        //                 ));
        //             context.pop();
        //           },
        //         );
        //       },
        //       child: Icon(
        //         Icons.delete_forever_outlined,
        //         color: Colors.red,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Product product;
  final String productId;

  const _ProductView({required this.product, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: productForm.images),
        ),
        const SizedBox(height: 10),
        Center(
            child: Text(
          productForm.title.value,
          style: textStyles.titleSmall,
          textAlign: TextAlign.center,
        )),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
        const SizedBox(height: 40),
        _ButtonsSaveDelete(productId: productId),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _ButtonsSaveDelete extends ConsumerStatefulWidget {
  const _ButtonsSaveDelete({required this.productId});
  final String productId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ButtonsSaveDeleteState();
}

class _ButtonsSaveDeleteState extends ConsumerState<_ButtonsSaveDelete> {
  bool isChecked = false;
  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }
    return Colors.red.withOpacity(.9);
  }

  void showCenterOverlay(BuildContext context,
      {required String message, required Icon icon}) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            height: 150,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider(widget.productId));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Save',
              buttonColor: Colors.blue.withOpacity(.7),
              onPressed: () {
                if (productState.product == null) return;
                ref
                    .read(productFormProvider(productState.product!).notifier)
                    .onFormSubmit()
                    .then(
                  (value) {
                    // en realidad me gusta enterarme qué pasó
                    if (!value || !context.mounted) {
                      return; // no me gusta que no haga nada
                    }
                    // Hago la validación del mounted por seguridad
                    // para evitar un posible fallo al usar el context
                    showCenterOverlay(context,
                        message: 'Product has been updated',
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 60,
                        ));
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Checkbox(
                value: isChecked,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: CustomFilledButton(
                    text: !isChecked ? 'Delete' : "are you sure?",
                    buttonColor: Colors.red.withOpacity(.9),
                    onPressed: isChecked
                        ? () {
                            if (productState.product == null) return;
                            ref
                                .read(productFormProvider(productState.product!)
                                    .notifier)
                                .deleteProduct(widget.productId)
                                .then(
                              (value) {
                                // en realidad me gusta enterarme qué pasó
                                if (!value || !context.mounted) {
                                  return; // no me gusta que no haga nada
                                }
                                // Hago la validación del mounted por seguridad
                                // para evitar un posible fallo al usar el context

                                showCenterOverlay(context,
                                    message: 'Product successfully removed!',
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.red,
                                      size: 60,
                                    ));
                                context.pop();
                              },
                            );
                          }
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onTitleChanged,
            errorMessage: productForm.title.errorMessage,
          ),
          CustomProductField(
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onSlugChanged,
            errorMessage: productForm.slug.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            // Con decimales, aunque permite escribir dos comas, eso tendría que mejorarlo
            // creo que en la app de la calculadora lo hice
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[.0-9]'))
            ],
            initialValue: productForm.price.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onPriceChanged,
            errorMessage: productForm.price.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSizesChanged:
                ref.read(productFormProvider(product).notifier).onSizesChanged,
          ),
          const SizedBox(height: 5),
          _GenderSelector(
            selectedGender: productForm.gender,
            onGenderChanged:
                ref.read(productFormProvider(product).notifier).onGenderChanged,
          ),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            // solo números enteros con éste inputFormatters
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            initialValue: productForm.inStock.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onStockChanged,
            errorMessage: productForm.inStock.errorMessage,
          ),
          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.description,
            onChanged: ref
                .read(productFormProvider(product).notifier)
                .onDescriptionChanged,
          ),
          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.tags,
            onChanged:
                ref.read(productFormProvider(product).notifier).onTagsChanged,
          ),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  final void Function(List<String> sizes) onSizesChanged;

  const _SizeSelector({
    required this.selectedSizes,
    required this.onSizesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSizesChanged(List.from(newSelection));
        //debugPrint(newSelection.toString());
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];
  final void Function(String selectedGender) onGenderChanged;

  const _GenderSelector(
      {required this.selectedGender, required this.onGenderChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          FocusScope.of(context).unfocus();
          onGenderChanged(newSelection.first);
          //debugPrint(newSelection.toString());
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.isEmpty
          ? [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.asset('assets/images/no-image.jpg',
                      fit: BoxFit.cover))
            ]
          : images.map((e) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  e,
                  fit: BoxFit.cover,
                  errorBuilder: (context, child, stackTrace) =>
                      CircularProgressIndicator(),
                ),
              );
            }).toList(),
    );
  }
}
