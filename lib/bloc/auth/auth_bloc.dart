import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_huntlng/models/rating.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';
import 'package:hr_huntlng/repository/rating/rating_service.dart';
import 'package:connectivity/connectivity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthService _authenticationService = AuthService();
  RatingService _ratingService = RatingService();
  AuthBloc() : super(const AuthState());

  AuthState get initialState => AuthenticationInitial();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }

    if (event is IntroToLogin) {
      yield* _mapIntroToLogin();
    }

    if (event is LoginToIntro) {
      yield* _mapLoginToIntro();
    }
  }

  Stream<AuthState> _mapLoginToIntro() async* {
    yield AuthenticationIntroSlider();
  }

  Stream<AuthState> _mapIntroToLogin() async* {
    yield AuthenticationNotAuthenticated();
  }

  Stream<AuthState> _mapAppLoadedToState(AppLoaded event) async* {
    // String quizname = await _preferenceRepository.getData('data');
    yield AuthenticationLoading(); // to display splash screen
    await Future.delayed(Duration(seconds: 2));
    print('AuthenticationLoading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        // a simulated delay
        User currentUser = await _authenticationService.getCurrentuser();

        if (currentUser != null) {
          if (currentUser.email != null) {
            if (currentUser.email.contains('@admin.com')) {
              yield AuthenticationAdmin(
                user: currentUser,
              );
            } else {
              yield AuthenticationAuthenticated(user: currentUser);
            }
          } else {
            yield AuthenticationAuthenticated(user: currentUser);
          }
        } else {
          await _authenticationService.signOut();

          yield AuthenticationIntroSlider();
          // yield AuthenticationNotAuthenticated();
        }
      } catch (e) {
        yield AuthenticationFailure(
            message: e.message ?? 'An unknown error occurred');
        print('An unknown error occurred');
      }
    } else {
      yield AuthenticationIntroSlider();
    }
  }

  Stream<AuthState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    // yield AuthenticationLoading();
    if (event.user.email != null) {
      if (event.user.email.contains('@admin.com')) {
        yield AuthenticationAdmin(
          user: event.user,
        );
      } else {
        yield AuthenticationAuthenticated(user: event.user);
      }
    } else {
      yield AuthenticationAuthenticated(user: event.user);
    }
  }

  Stream<AuthState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    await _authenticationService.signOut();
    yield AuthenticationNotAuthenticated();
  }
}
