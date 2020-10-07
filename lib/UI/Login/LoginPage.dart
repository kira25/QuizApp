import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/UI/ForgotPassword/ForgotPassword.dart';
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
  AuthBloc authBloc;

  SignInForm({
    this.authBloc,
    Key key,
  }) : super(key: key);

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(wp(14)),
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
                              autofocus: true,
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
                                hintText: 'example@live.com',
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
                          new Expanded(
                            child: new Padding(
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
                                hintText: '*********',
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: wp(5)),
                            child: new FlatButton(
                              child: new Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontFamily: fontOswaldRegular,
                                  color: kdarkprimarycolor,
                                  fontSize: wp(4),
                                ),
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword(
                                            authBloc: authBloc,
                                          ))),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: hp(6),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 20.0),
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                color: kaccentcolor,
                                onPressed: state is LoginLoading
                                    ? null
                                    : _onLoginButtonPressed,
                                child: new Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 20.0,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Text(
                                          "Login",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: wp(4),
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
