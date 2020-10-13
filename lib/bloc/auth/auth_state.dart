part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthState {}

class AuthenticationLoading extends AuthState {}

class AuthenticationNotAuthenticated extends AuthState {}

class AuthenticationAuthenticated extends AuthState {
  final User user;

  AuthenticationAuthenticated({this.user});

  @override
  List<Object> get props => [user];
}

class AuthenticationFailure extends AuthState {
  final String message;

  AuthenticationFailure({this.message});

  @override
  List<Object> get props => [message];
}

class AuthenticationAdmin extends AuthState {
  final User user;
  final data;

  AuthenticationAdmin({this.user, this.data});
  @override
  List<Object> get props => [user, data];
}
