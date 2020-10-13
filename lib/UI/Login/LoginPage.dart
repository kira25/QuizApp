import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/UI/ForgotPassword/ForgotPassword.dart';
import 'package:hr_huntlng/UI/Register/RegisterPage.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/login/login_bloc.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:shimmer/shimmer.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          child: BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(context.bloc<AuthBloc>()),
            child: SignInForm(),
          ),
        );
      },
    ));
  }
}

class SignInForm extends StatelessWidget {
  SignInForm({
    Key key,
  }) : super(key: key);

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    print(wp(100));
    print(hp(100));

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
              child: SizedBox(
                width: 200.0,
                height: 100.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.red,
                  highlightColor: Colors.yellow,
                  child: Text(
                    'Loading',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          } else {
            //LOGIN
            return SafeArea(
              child: new Container(
                height: hp(100),
                width: wp(100),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: new Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    ClipPath(
                      child: Container(
                        height: hp(75),
                        width: wp(100),
                        color: kbluelogincolor,
                      ),
                      clipper: CustomClipPathBlue(),
                    ),
                    ClipPath(
                      child: Container(
                        height: hp(60),
                        width: wp(100),
                        color: kdarklogincolor,
                      ),
                      clipper: CustomClipPathDark(),
                    ),
                    ClipPath(
                      child: Container(
                        height: hp(20),
                        width: wp(80),
                        color: klightlogincolor,
                      ),
                      clipper: CustomClipPathOrange(),
                    ),

                    // Positioned(
                    //   top: hp(2),
                    //   left: wp(10),
                    //   child: Container(
                    //     padding: EdgeInsets.only(
                    //         left: wp(2),
                    //         right: wp(2),
                    //         top: hp(10),
                    //         bottom: hp(3)),
                    //     child: Center(
                    //         child: Image.asset(
                    //       './assets/examen.png',
                    //       height: hp(15),
                    //       width: wp(25),
                    //     )),
                    //   ),
                    // ),
                    Positioned(
                      top: hp(20),
                      left: wp(14),
                      child: Text(
                        'Welcome to \nthe Quiz',
                        style: TextStyle(
                            fontFamily: fontSintonyBold,
                            color: Colors.white,
                            fontSize: wp(8)),
                      ),
                    ),

                    Positioned(
                      bottom: hp(28),
                      left: wp(10),
                      right: wp(10),
                      child: Column(
                        children: [
                          TextField(
                            autofocus: false,
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
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: hp(3),
                          ),
                          TextField(
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
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: hp(13),
                      left: wp(10),
                      child: Row(children: [
                        Text(
                          'Sign in',
                          style: TextStyle(
                              fontFamily: fontOswaldBold,
                              fontSize: wp(6),
                              color: kdarkprimarycolor),
                        ),
                        SizedBox(
                          width: wp(45),
                        ),
                        GestureDetector(
                          onTap: state.username.invalid == true ||
                                  state.password.invalid == true
                              ? null
                              : _onLoginButtonPressed,
                          child: ClipOval(
                            child: Container(
                              height: hp(10),
                              width: wp(18),
                              color: state.username.invalid == true ||
                                      state.password.invalid == true
                                  ? Colors.grey
                                  : kdarklogincolor,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),

                    Positioned(
                      bottom: hp(6),
                      left: wp(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage())),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: fontOswaldBold,
                                  fontSize: wp(4.5),
                                  color: kdarkprimarycolor),
                            ),
                          ),
                          SizedBox(
                            width: wp(32),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword())),
                            child: Hero(
                              tag: 'ForgotPassword',
                              transitionOnUserGestures: true,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class CustomClipPathOrange extends CustomClipper<Path> {
  var radius = 15.0;
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.9,
        size.width * 0.35, size.height * 0.42);

    path.quadraticBezierTo(
        size.width * 0.45, size.height * 0.15, size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomClipPathDark extends CustomClipper<Path> {
  var radius = 15.0;
  @override
  getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.9,
        size.width * 0.50, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.50,
        size.width * 0.85, size.height * 0.35);
    path.quadraticBezierTo(
        size.width * 0.95, size.height * 0.28, size.width, size.height * 0.20);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomClipPathBlue extends CustomClipper<Path> {
  var radius = 15.0;
  @override
  getClip(Size size) {
    var path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.70);

    path.quadraticBezierTo(size.width * 0.4, size.height * 0.7, 0, 0);

    path.close();

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
