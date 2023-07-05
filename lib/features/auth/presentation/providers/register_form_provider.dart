import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

//Provider

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegsiterFormState>(
        (ref) {
  final loginUserCallBack = ref.watch(authProvider.notifier).loginUser;
  return RegisterFormNotifier(loginUserCallBack);
});

//Notifier

class RegisterFormNotifier extends StateNotifier<RegsiterFormState> {
  final Future<void> Function(String, String) loginUserCallBack;
  RegisterFormNotifier(this.loginUserCallBack) : super(RegsiterFormState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  void rePasswordChanged(String rePassword) {
    final newPassword = state.password.value;
    if (newPassword == rePassword) state.copyWith(passwordIsMatch: true);
    state.copyWith(passwordIsMatch: false);
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;

    await loginUserCallBack(state.email.value, state.password.value);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      passwordIsMatch: state.passwordIsMatch,
      isValid: Formz.validate([email, password]),
    );
  }
}

//State

class RegsiterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final bool passwordIsMatch;

  RegsiterFormState({
    this.passwordIsMatch = true,
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  RegsiterFormState copyWith(
          {final bool? isPosting,
          final bool? isFormPosted,
          final bool? isValid,
          final Email? email,
          final Password? password,
          final bool? passwordIsMatch}) =>
      RegsiterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password,
          passwordIsMatch: passwordIsMatch ?? this.passwordIsMatch);
  @override
  String toString() {
    return '''
    isPosting:$isPosting,
    isformPosted:$isFormPosted,
    isValid:$isValid,
    emailt:$email,
    password:$password
    isPasswordMatch:$passwordIsMatch
''';
  }
}
