import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/features/auth/auth.dart';
import 'package:teslo_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_app/features/products/products.dart';

import 'app_router_notifier.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  //* El objetivo de envcerra el goRouter con un provider, es para saber si el usuario está autenticado
  //* ó no, es para proteger las rutas, especialmente en la web, en donde un usuario puede llegar
  //* a una parte especifica del programa sin estar autenticado
  //* ESTO SE LLAMA PROTECCIÓN DE RUTAS
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      //* Primera Pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckOutStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
    ],
    redirect: (context, state) {
      // con esto se validan todas las rutas, porque todas pasan por aqui
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;
      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null; // lo deja tranquilo que vaya a splash
      }
      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') {
          // cuando se coloca null, es para dejar que vaya a la pantalla que quiera
          return null;
        }
        // lo redigirimos al login porque no está autenticado
        return '/login';
      }
      if (authStatus == AuthStatus.authenticated) {
        // es importante hacer éstas comprobaciones, porque el usuario es posible que llegue
        // por un deep link
        if (isGoingTo == '/login' || isGoingTo == '/register') {
          // lo mandamos a la ruta principal, porque ya está autenticado
          return '/';
        }
      }
      //! Aquí podríamos verificar si el usuario es admin y redirigirlo a una ruta específica
      // final auth = ref.read(authProvider);
      // if (auth.user?.isAdmin ?? false) {
      //   // y hacemos las consideraciones necesarias para redirigir al usuario
      //   // a determinadas pantallas
      // }
      //* También dice que podemos determinar qué página era la que se encontraba mediante argumentos
      //* y almacenarlos, porque puede ser que la persona quiera regresar

      return null;
    },

    ///! TODO: Bloquear si no se está autenticado de alguna manera
  );
});
