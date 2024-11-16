//! 1 - State del provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_app/features/auth/presentation/providers/providers.dart';
import 'package:teslo_app/features/shared/shared.dart';

//! 3 - StateNotifierProvider - consume afuera

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUser = ref.read(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUser: registerUser);
});

//! 2 - Como implementamos un Notifier

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier({required this.registerUser})
      : super(RegisterFormState());

  final Future<void> Function(String, String, String) registerUser;

  void onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([
          newEmail,
          state.password,
          state.fullName,
          state.repeatPassword,
        ]));
  }

  void onFullNameChange(String value) {
    final newFullName = FullName.dirty(value);
    state = state.copyWith(
        fullName: newFullName,
        isValid: Formz.validate([
          newFullName,
          state.email,
          state.password,
          state.repeatPassword,
        ]));
  }

  void onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([
          newPassword,
          state.email,
          state.fullName,
          state.repeatPassword,
        ]));
  }

  void onRepeatPasswordChange(String value) {
    final newRepeatPassword =
        RepeatPassword.dirty(value: value, password: state.password.value);
    state = state.copyWith(
        repeatPassword: newRepeatPassword,
        isValid: Formz.validate([
          newRepeatPassword,
          state.email,
          state.fullName,
          state.password,
        ]));
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    // si todo está bien hago print del state
    //debugPrint(state.toString());
    state = state.copyWith(isPosting: true);
    await registerUser(
      state.email.value,
      state.password.value,
      state.fullName.value,
    );
    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = FullName.dirty(state.fullName.value);
    final repeatPassword = RepeatPassword.dirty(
        value: state.repeatPassword.value, password: state.password.value);
    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        repeatPassword: repeatPassword,
        fullName: fullName,
        isValid: Formz.validate([email, password, fullName, repeatPassword]));
  }
}

//! 1 - State del provider

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final RepeatPassword repeatPassword;
  final FullName fullName;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.repeatPassword = const RepeatPassword.pure(),
    this.fullName = const FullName.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    RepeatPassword? repeatPassword,
    FullName? fullName,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword,
        fullName: fullName ?? this.fullName,
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
    fullName: $fullName
    repeatPassword: $repeatPassword
''';
  }
}
