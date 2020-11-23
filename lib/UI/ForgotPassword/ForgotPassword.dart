import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/login/login_bloc.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return Hero(
      tag: 'ForgotPassword',
      transitionOnUserGestures: true,
      child: Scaffold(
        body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(context.bloc<AuthBloc>()),
          child: KeyboardVisibilityProvider(
            child: SendEmail(
              wp: wp,
              hp: hp,
              emailController: emailController,
            ),
          ),
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
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Check your inbox'),
          ));
      Navigator.pop(context);
    }

    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return SafeArea(
        child: Container(
          height: hp(100),
          width: wp(100),
          color: Colors.white,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: wp(6), top: hp(3)),
                child: Row(
                  children: [
                    IconButton(
                        iconSize: wp(8),
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context))
                  ],
                ),
              ),
              SizedBox(
                height: hp(6),
              ),
              Column(
                children: [
                  Image.asset(
                    './assets/examen.png',
                    height: hp(15),
                    width: wp(30),
                  ),
                  SizedBox(
                    height: hp(4),
                  ),
                  Text(
                    'Quiz',
                    style: TextStyle(
                        fontFamily: fontOswaldBold,
                        color: kdarkprimarycolor,
                        fontSize: wp(6)),
                  ),
                ],
              ),
              SizedBox(
                height: hp(6),
              ),
              Container(
                height: hp(15),
                width: wp(70),
                margin:
                    EdgeInsets.only(left: wp(10), right: wp(10), top: hp(1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please enter your email',
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
                height: hp(6),
              ),
              isKeyboardVisible == true
                  ? Container()
                  : BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return Container(
                          width: wp(85),
                          height: hp(8),
                          margin: EdgeInsets.only(
                              left: wp(7), right: wp(7), top: hp(2)),
                          child: RaisedButton(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: kaccentcolor,
                            onPressed: state.username.invalid == true ||
                                    state.username.value.isEmpty == true
                                ? null
                                : _onForgotPassword,
                            child: Text(
                              "Confirm",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: wp(4),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      );
    });
  }
}
