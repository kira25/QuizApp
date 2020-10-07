import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/login/login_bloc.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';

class ForgotPassword extends StatelessWidget {
  AuthBloc authBloc;
  TextEditingController emailController = TextEditingController();
  ForgotPassword({this.authBloc});

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    final authService = RepositoryProvider.of<AuthService>(context);

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
        child: SendEmail(
          wp: wp,
          hp: hp,
          emailController: emailController,
          // function: _onForgotPassword,
        ),
      ),
    );
  }
}

class SendEmail extends StatelessWidget {
  SendEmail({
    Key key,
    this.wp,
    this.hp,
    this.function,
    this.emailController,
  });

  final Function wp;
  final Function hp;
  final TextEditingController emailController;
  final Function function;

  @override
  Widget build(BuildContext context) {
    _onForgotPassword() {
      context.bloc<LoginBloc>().add(LoginForgotPassword(emailController.text));
      Navigator.pop(context);
      print('forgot password');
    }

    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(wp(14)),
                child: Center(
                    child: Image.asset(
                  './assets/examen.png',
                  height: hp(15),
                  width: wp(30),
                )),
              ),
              Text(
                'Quiz',
                style: TextStyle(
                    fontFamily: fontOswaldBold,
                    color: kdarkprimarycolor,
                    fontSize: wp(6)),
              ),
              SizedBox(
                height: hp(4),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: wp(10), right: wp(10), top: hp(1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: fontOswaldBold,
                        color: kdarkprimarycolor,
                        fontSize: wp(5),
                      ),
                    ),
                    TextField(
                      autofocus: true,
                      onChanged: (value) {
                        context
                            .bloc<LoginBloc>()
                            .add(LoginUsernameChanged(value));
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        errorText: state.username.invalid == true
                            ? 'Invalid username'
                            : null,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: wp(0.5), color: kdarkprimarycolor)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: wp(0.5), color: kdarkprimarycolor)),
                        errorStyle: TextStyle(
                            fontFamily: fontOswaldRegular,
                            color: kaccentcolor,
                            fontSize: wp(4)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: hp(20),
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 20.0),
                    alignment: Alignment.center,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            color: kaccentcolor,
                            onPressed: state.username.invalid == true ||
                                    state.username.value.isEmpty == true
                                ? null
                                : _onForgotPassword,
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
                                      "Confirmar",
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
                  );
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
