part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState(
      {this.username = const Username.pure(),
      this.password = const Password.pure(),
      this.displayName});

  final Username username;
  final Password password;
  final String displayName;

  LoginState copyWith(
      {Username username, Password password, String displayName}) {
    return LoginState(
        username: username ?? this.username,
        password: password ?? this.password,
        displayName: displayName ?? this.displayName);
  }

  @override
  List<Object> get props => [username, password, displayName];
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

class RegisterLoading extends LoginState {}

class RegisterSuccess extends LoginState {}

class LoginWithGoogleLoading extends LoginState {}

class SaveQuiznameSuccess extends LoginState {
  final String savedQuizname;

  SaveQuiznameSuccess({this.savedQuizname});
  @override
  List<Object> get props => [savedQuizname];
}
