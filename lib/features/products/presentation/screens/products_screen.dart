import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/config/router/app_router.dart';
import 'package:teslo_app/features/products/presentation/providers/providers.dart';
import 'package:teslo_app/features/products/presentation/widgets/widgets.dart';
import 'package:teslo_app/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ProductsViewState();
}

class __ProductsViewState extends ConsumerState<_ProductsView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // todo: infinito scroll pendiente
    scrollController.addListener(_infinitScrollListener);
    //loadNextPage();
  }

  void loadNextPage() {
    ref.read(productsProvider.notifier).loadNextPage();
  }

  void _infinitScrollListener() {
    final maxScrollExtent = scrollController.position.maxScrollExtent;
    final pixels = scrollController.position.pixels;
    // debugPrint('maxScrollExtent: $maxScrollExtent');
    // debugPrint('pixels: $pixels');
    if (pixels > (maxScrollExtent - 400)) {
      loadNextPage();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_infinitScrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        physics: BouncingScrollPhysics(),
        controller: scrollController,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          final product = productsState.products[index];
          return GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: ProductCard(
              product: product,
            ),
          );
        },
      ),
    );
  }
}
