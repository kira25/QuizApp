import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_huntlng/models/rating.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';
import 'package:hr_huntlng/repository/rating/rating_service.dart';

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
  }

  Stream<AuthState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading(); // to display splash screen
    await Future.delayed(Duration(seconds: 1));
    print('AuthenticationLoading');
    try {
      // a simulated delay
      User currentUser = await _authenticationService.getCurrentuser();

      if (currentUser != null) {
        if (currentUser.email == 'erick.gutierrez@pucp.pe') {
          List<RatingData> data = await _ratingService.readData();
          yield AuthenticationAdmin(user: currentUser, data: data);
        } else {
          yield AuthenticationAuthenticated(user: currentUser);
        }
      } else {
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(
          message: e.message ?? 'An unknown error occurred');
    }
  }

  Stream<AuthState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    yield AuthenticationLoading();
    if (event.user.email == 'erick.gutierrez@pucp.pe') {
      List<RatingData> data = await _ratingService.readData();
      yield AuthenticationAdmin(user: event.user, data: data);
    } else {
      yield AuthenticationAuthenticated(user: event.user);
    }
  }

  Stream<AuthState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    await _authenticationService.signOut();
    yield AuthenticationNotAuthenticated();
  }
}
