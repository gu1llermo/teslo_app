import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/presentation/providers/providers.dart';

//* Esto lo hace Fernando por un truco para poder refrescar el appRouter y poder
//* usar su redirect, y así poder redireccionar correctamente al usuario
//* dependiendo de si está autenticado ó no

final goRouterNotifierProvider = Provider<GoRouterNotifier>((ref) {
  final authnotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authnotifier);
});

class GoRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier(this._authNotifier) {
    _authNotifier.addListener(
      (state) {
        authStatus = state.authStatus;
        // es impresionante como elaboró ésta cadena
        // de notificaciones, para darse cuenta de los cambios de estado
        // de autentificación del usuario
      },
    );
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }
}
