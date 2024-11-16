import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_app/features/auth/presentation/providers/providers.dart';
import 'package:teslo_app/features/shared/shared.dart';

//! 3 - StateNotifierProvider - consume afuera

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUser = ref.read(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUser: loginUser);
});

//! 2 - Como implementamos un Notifier

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier({required this.loginUser}) : super(LoginFormState());

  final Future<void> Function(String, String) loginUser;

  void onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  void onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;

    // está haciendo esto con la finalidad deshabilitar el botón de posteo
    // para que el usuario no presione dos veces ó ingrese dos veces
    // al mismo tiempo, es como una medida de seguridad
    state = state.copyWith(isPosting: true);

    await loginUser(state.email.value, state.password.value);

    Future.delayed(
      Duration(seconds: 1),
      () {
        if (mounted) {
          state = state.copyWith(isPosting: false);
        }
      },
    );
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

//! 1 - State del provider

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
  LoginFormSate:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
''';
  }
}
