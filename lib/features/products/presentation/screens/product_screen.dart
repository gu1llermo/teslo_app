import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/products/presentation/providers/providers.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_outlined))
        ],
      ),
      body: Center(
        child: Text(productState.product?.title ?? 'Cargando...'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save_as_outlined),
      ),
    );
  }
}

// class ProductScreen extends ConsumerStatefulWidget {
//   const ProductScreen({super.key, required this.productId});
//   // es preferible hacer la llamada al backend nevamente teniendo el id
//   // del producto, es ás versátil así y tiene la data actualizada en todo momento
//   final String productId;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _ProductScreenState();
// }

// class _ProductScreenState extends ConsumerState<ProductScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // autmaticamente dentro del constructor de productNotifier se hace la petición al producto
//     // y se carga en su estado
//     ref.read(productProvider(widget.productId).notifier);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Editar Producto'),
//       ),
//       body: Center(
//         child: Text(widget.productId),
//       ),
//     );
//   }
// }
