part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginInWithEmailButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginInWithEmailButtonPressed({this.username, this.password});

  @override
  List<Object> get props => [username, password];
}

class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginForgotPassword extends LoginEvent {
  final String username;

  LoginForgotPassword(this.username);
  @override
  List<Object> get props => [username];
}