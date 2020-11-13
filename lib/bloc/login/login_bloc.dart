import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/models/password.dart';
import 'package:hr_huntlng/models/rating.dart';
import 'package:hr_huntlng/models/username.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';
import 'package:hr_huntlng/repository/preferences/preferences_repository.dart';
import 'package:hr_huntlng/repository/rating/rating_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _authenticationBloc;
  AuthService _authenticationService = AuthService();
  RatingService _ratingService = RatingService();
  PreferenceRepository _preferenceRepository = PreferenceRepository();
  String quizname;
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
    } else if (event is LoginWithGoogle) {
      yield* _mapLoginWithGoogle();
    } else if (event is SaveQuizname) {
      yield* _mapSaveQuizname(event);
    } else if (event is LoadQuizNameEvent) {
      yield* _mapLoadQuizNameEvent();
    } else if (event is LoginAnonymusly) {
      yield* _mapLoginAnonymusly();
    }
  }

  Stream<LoginState> _mapLoginAnonymusly() async* {
    User user = await _authenticationService.signInAnonymus();
    yield LoginLoading();
    _authenticationBloc.add(UserLoggedIn(user: user));
  }

  Stream<LoginState> _mapLoadQuizNameEvent() async* {
    quizname = await _preferenceRepository.getQuizname();
    print('LoadQuizNameEvent : $quizname');
    yield SaveQuiznameSuccess(savedQuizname: quizname);
  }

  Stream<LoginState> _mapSaveQuizname(
    SaveQuizname event,
  ) async* {
    await _preferenceRepository.setData('data', event.quizname);
    quizname = await _preferenceRepository.getQuizname();
    print('SaveQuizname: $quizname');
    yield SaveQuiznameSuccess(savedQuizname: quizname);
  }

  Stream<LoginState> _mapLoginWithGoogle() async* {
    yield LoginWithGoogleLoading();
    User user = await _authenticationService.signInWithGoogle();
    yield LoginLoading();
    if (user != null) {
      _authenticationBloc.add(UserLoggedIn(user: user));
    } else {
      yield LoginFailure(error: "Error sign in with Google acount");
    }
  }

  Stream<LoginState> _mapRegisterButtonPressed(
      RegisterButtonPressed event, LoginState state) async* {
    yield RegisterLoading();
    User user = await _authenticationService.createAccount(
        state.username.value, state.password.value);

    await _authenticationService.updateProfile(user, state.displayName);
    yield RegisterSuccess();

    // await _authenticationService.signInWithEmailAndPassword(
    //     state.username.value, state.password.value);

    // _authenticationBloc.add(UserLoggedIn(user: updateUser));
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
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        User user = await _authenticationService.signInWithEmailAndPassword(
            event.username, event.password);

        yield LoginSuccess();
        if (user != null) {
          if (user.email.contains("@admin.com")) {
            try {
              // push new authentication event
              _authenticationBloc.add(UserLoggedIn(user: user));
            } catch (e) {
              print('Login :No data in Admin');
              yield LoginFailure(error: "No data in Admin");
              await _authenticationService.signOut();
            }
          } else {
            // push new authentication event
            _authenticationBloc.add(UserLoggedIn(user: user));
          }
        } else {
          yield LoginFailure(error: 'Incorrect password or email');
        }
      } else {
        yield LoginFailure(error: "Fail to connect");
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
