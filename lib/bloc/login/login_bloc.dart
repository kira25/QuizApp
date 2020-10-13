import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/models/password.dart';
import 'package:hr_huntlng/models/username.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _authenticationBloc;
  AuthService _authenticationService = AuthService();

  LoginBloc(AuthBloc authenticationBloc)
      : assert(authenticationBloc != null),
        _authenticationBloc = authenticationBloc,
        super(const LoginState());

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInWithEmailButtonPressed) {
      yield* _mapLoginWithEmailToState(event);
    } else if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginForgotPassword) {
      yield* _mapLoginSendPassword(event);
    } else if (event is RegisterDisplayNameChanged) {
      yield _mapRegisterDisplayNameChanged(event, state);
    } else if (event is RegisterButtonPressed) {
      yield* _mapRegisterButtonPressed(event, state);
    }
  }

  Stream<LoginState> _mapRegisterButtonPressed(
      RegisterButtonPressed event, LoginState state) async* {
    User user = await _authenticationService.createAccount(
        state.username.value, state.password.value);
    User updateUser =
        await _authenticationService.updateProfile(user, state.displayName);
    yield RegisterSuccess();
    await _authenticationService.signInWithEmailAndPassword(
        state.username.value, state.password.value);

    _authenticationBloc.add(UserLoggedIn(user: updateUser));
    yield LoginSuccess();
    yield LoginInitial();
  }

  LoginState _mapRegisterDisplayNameChanged(
      RegisterDisplayNameChanged event, LoginState state) {
    return state.copyWith(displayName: event.displayName);
  }

  LoginState _mapUsernameChangedToState(
    LoginUsernameChanged event,
    LoginState state,
  ) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
    );
  }

  LoginState _mapPasswordChangedToState(
    LoginPasswordChanged event,
    LoginState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
    );
  }

  Stream<LoginState> _mapLoginWithEmailToState(
      LoginInWithEmailButtonPressed event) async* {
    if (event.username.isEmpty && event.password.isEmpty) {
      yield LoginFailure(error: 'Please fill the gaps');
    } else {
      yield LoginLoading();

      User user = await _authenticationService.signInWithEmailAndPassword(
          event.username, event.password);
      yield LoginSuccess();
      if (user != null) {
        // push new authentication event
        _authenticationBloc.add(UserLoggedIn(user: user));

        yield LoginInitial();
      } else {
        yield LoginFailure(error: 'Incorrect password or email');
        yield LoginInitial();
      }
    }
  }

  Stream<LoginState> _mapLoginSendPassword(LoginForgotPassword event) async* {
    if (event.username.isNotEmpty) {
      yield LoginSendPassword();
      print('LoginSendPassword');
      await _authenticationService.sendPasswordResetEmail(event.username);
    }
  }
}
