import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/UI/ForgotPassword/ForgotPassword.dart';
import 'package:hr_huntlng/UI/Register/RegisterPage.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/login/login_bloc.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final authenticationBloc = BlocProvider.of<AuthBloc>(context);
        final authService = RepositoryProvider.of<AuthService>(context);
        if (state is AuthenticationNotAuthenticated) {
          return Container(
            child: BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(authenticationBloc, authService),
              child: SignInForm(
                authBloc: authenticationBloc,
              ),
            ),
          );
        }
        if (state is AuthenticationFailure) {
          // show error message
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(state.message),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Retry'),
                onPressed: () {
                  authenticationBloc.add(AppLoaded());
                },
              )
            ],
          ));
        }
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      },
    ));
  }
}

class SignInForm extends StatelessWidget {
  SignInForm({
    this.authBloc,
    Key key,
  }) : super(key: key);

  final AuthBloc authBloc;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    _onLoginButtonPressed() {
      context.bloc<LoginBloc>().add(LoginInWithEmailButtonPressed(
          username: _emailController.text, password: _passwordController.text));
    }

    void _showError(String error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(error),
      ));
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Form(
              key: _key,
              child: SingleChildScrollView(
                child: new Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: new Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(wp(23)),
                        child: Center(
                            child: Image.asset(
                          './assets/examen.png',
                          height: hp(15),
                          width: wp(30),
                        )),
                      ),
                      new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Padding(
                              padding: EdgeInsets.only(
                                left: wp(10),
                              ),
                              child: new Text(
                                "Email",
                                style: TextStyle(
                                  fontFamily: fontOswaldBold,
                                  color: kdarkprimarycolor,
                                  fontSize: wp(5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Container(
                        margin: EdgeInsets.only(
                            left: wp(10), right: wp(10), top: hp(1)),
                        child: BlocBuilder<LoginBloc, LoginState>(
                          buildWhen: (previous, current) =>
                              previous.username != current.username,
                          builder: (context, state) {
                            return TextField(
                              autofocus: false,
                              key: const Key(
                                  'loginForm_usernameInput_textField'),
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              onChanged: (username) => context
                                  .bloc<LoginBloc>()
                                  .add(LoginUsernameChanged(username)),
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: wp(0.5),
                                        color: kdarkprimarycolor)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: wp(0.5),
                                        color: kdarkprimarycolor)),
                                errorStyle: TextStyle(
                                    fontFamily: fontOswaldRegular,
                                    color: kaccentcolor,
                                    fontSize: wp(4)),
                                errorText: state.username.invalid
                                    ? 'Invalid username'
                                    : null,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: hp(4),
                      ),
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(left: wp(10)),
                            child: new Text(
                              "Password",
                              style: TextStyle(
                                fontFamily: fontOswaldBold,
                                color: kdarkprimarycolor,
                                fontSize: wp(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Container(
                        margin: EdgeInsets.only(
                            left: wp(10), right: wp(10), top: hp(1)),
                        child: BlocBuilder<LoginBloc, LoginState>(
                          buildWhen: (previous, current) =>
                              previous.password != current.password,
                          builder: (context, state) {
                            return TextField(
                              onChanged: (value) => context
                                  .bloc<LoginBloc>()
                                  .add(LoginPasswordChanged(value)),
                              controller: _passwordController,
                              obscureText: true,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: wp(0.5),
                                        color: kdarkprimarycolor)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: wp(0.5),
                                        color: kdarkprimarycolor)),
                                errorStyle: TextStyle(
                                    fontFamily: fontOswaldRegular,
                                    color: kaccentcolor,
                                    fontSize: wp(4)),
                                errorText: state.password.invalid
                                    ? 'Invalid password'
                                    : null,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: hp(5),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Sign in',
                              style: TextStyle(
                                  fontFamily: fontOswaldBold,
                                  fontSize: wp(6),
                                  color: kdarkprimarycolor),
                            ),
                            ClipOval(
                              child: Container(
                                height: hp(8),
                                width: wp(16),
                                color: kaccentcolor,
                                child: BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, state) {
                                    return RaisedButton(
                                      onPressed: state.username.invalid ==
                                                  true ||
                                              state.password.invalid == true ||
                                              state.username.value.isEmpty ==
                                                  true ||
                                              state.password.value.isEmpty ==
                                                  true
                                          ? null
                                          : _onLoginButtonPressed,
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ]),
                      SizedBox(
                        height: hp(8),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage(
                                          authBloc: authBloc,
                                        ))),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: fontOswaldBold,
                                  fontSize: wp(4.5),
                                  color: kdarkprimarycolor),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword(
                                          authBloc: authBloc,
                                        ))),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontFamily: fontOswaldBold,
                                color: kdarkprimarycolor,
                                fontSize: wp(4.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
