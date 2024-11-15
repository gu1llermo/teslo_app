import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required this.authRepository}) : super(AuthState());
  final AuthRepository authRepository;

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.errorMessage);
    }
    // on WrongCredentials {
    //   logout('Credenciales no son correctas');
    // } on ConnectionTimeout {
    //   logout('Timeout');
    // }
    catch (e) {
      logout('Error no controlado');
    }
  }

  Future<void> registerUser(
      String email, String password, String fullName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.register(email, password, fullName);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.errorMessage);
    }
    // on WrongCredentials {
    //   logout('Credenciales no son correctas');
    // } on ConnectionTimeout {
    //   logout('Timeout');
    // }
    catch (e) {
      logout('Error no controlado');
    }
  }

  Future<void> checkAuthStatus(String token) async {}

  void _setLoggedUser(User user) {
    // todo: necesito guardar el token físicamente
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    //todo: limpiar token
    state = state.copyWith(
        user: null,
        authStatus: AuthStatus.notAuthenticated,
        errorMessage: errorMessage);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });
  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
