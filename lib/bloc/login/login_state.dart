part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  final Username username;
  final Password password;

  LoginState copyWith({
    Username username,
    Password password,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [username, password];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({this.error});

  @override
  List<Object> get props => [error];
}

class LoginSendPassword extends LoginState {}
