import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/auth/presentation/providers/providers.dart';
import 'package:teslo_app/features/shared/shared.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Icon Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (!context.canPop()) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 40, color: Colors.white)),
                const Spacer(flex: 1),
                Text('Crear cuenta',
                    style:
                        textStyles.titleLarge?.copyWith(color: Colors.white)),
                const Spacer(flex: 2),
              ],
            ),

            const SizedBox(height: 50),

            Container(
              height: size.height - 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _RegisterForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context, ref) {
    final registerForm = ref.watch(registerFormProvider);
    ref.listen(
      // con ésto solo escucho los cambios de authProvider, pero sin redibujar
      // ó reconstruir el widget
      authProvider,
      (previous, next) {
        if (next.errorMessage.isEmpty) return;
        AppUtils.showSnackbar(context, next.errorMessage);
      },
    );
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(flex: 2),
          Text('Nueva cuenta', style: textStyles.titleMedium),
          const Spacer(flex: 2),
          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            onChanged: ref.read(registerFormProvider.notifier).onFullNameChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.fullName.errorMessage
                : null,
          ),
          const Spacer(),
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.email.errorMessage
                : null,
          ),
          const Spacer(),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            textInputAction: TextInputAction.next,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.password.errorMessage
                : null,
          ),
          const Spacer(),
          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            onFieldSubmitted: (value) =>
                ref.read(registerFormProvider.notifier).onFormSubmit(),
            onChanged:
                ref.read(registerFormProvider.notifier).onRepeatPasswordChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.repeatPassword.errorMessage
                : null,
          ),
          const Spacer(),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Crear',
                buttonColor: Colors.black,
                onPressed: registerForm.isPosting
                    ? null
                    : ref.read(registerFormProvider.notifier).onFormSubmit,
              )),
          const Spacer(flex: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      return context.pop();
                    }
                    context.go('/login');
                  },
                  child: const Text('Ingresa aquí'))
            ],
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
