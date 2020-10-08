import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/UI/Home/HomePage.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/login/login_bloc.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';

class RegisterPage extends StatelessWidget {
  AuthBloc authBloc;

  RegisterPage({this.authBloc});

  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthService>(context);
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: kdarkprimarycolor,
            iconSize: wp(8),
            onPressed: () => Navigator.pop(context)),
      ),
      body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(authBloc, authService),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthenticationAuthenticated) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreen(
                              user: state.user,
                            )));
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(wp(3)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Create Account',
                          style: TextStyle(
                              fontFamily: fontOswaldBold,
                              fontSize: wp(6),
                              color: kdarkprimarycolor)),
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
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(
                            left: wp(10), right: wp(10), top: hp(1)),
                        child: BlocBuilder<LoginBloc, LoginState>(
                          buildWhen: (previous, current) =>
                              previous.password != current.password,
                          builder: (context, state) {
                            return TextField(
                              autofocus: false,
                              obscureText: true,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (password) => context
                                  .bloc<LoginBloc>()
                                  .add(LoginPasswordChanged(password)),
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
                                  hintText: 'Password'),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: wp(10), right: wp(10), top: hp(1)),
                        child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return TextField(
                              autofocus: false,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (displayName) => context
                                  .bloc<LoginBloc>()
                                  .add(RegisterDisplayNameChanged(displayName)),
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
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: 'Name'),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: hp(4),
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
                            BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                return ClipOval(
                                  child: Container(
                                    height: hp(8),
                                    width: wp(16),
                                    color: kaccentcolor,
                                    child: BlocBuilder<LoginBloc, LoginState>(
                                      builder: (context, state) {
                                        return RaisedButton(
                                          onPressed: state.username.invalid ==
                                                      true ||
                                                  state.password.invalid ==
                                                      true ||
                                                  state.username.value
                                                          .isEmpty ==
                                                      true ||
                                                  state.password.value
                                                          .isEmpty ==
                                                      true
                                              ? null
                                              : () => context
                                                  .bloc<LoginBloc>()
                                                  .add(RegisterButtonPressed()),
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                          ]),
                    ],
                  ),
                );
              },
            ),
          )),
    );
  }
}
