import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hr_huntlng/UI/ForgotPassword/ForgotPassword.dart';
import 'package:hr_huntlng/UI/Register/RegisterPage.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/login/login_bloc.dart';
import 'package:hr_huntlng/commons/customClipthPath.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthenticationFailure) {
          return Container(
            child: Center(
              child: Text('${state.message}'),
            ),
          );
        }
        return Container(
          child: BlocProvider<LoginBloc>(
              create: (context) =>
                  LoginBloc(context.bloc<AuthBloc>())..add(LoadQuizNameEvent()),
              child: KeyboardVisibilityProvider(child: SignInForm())),
        );
      },
    ));
  }
}

class SignInForm extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _quiznameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    print(wp(100));
    print(hp(100));
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

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
          if (state is LoginLoading || state is LoginSuccess) {
            return Container(
              width: wp(100),
              height: hp(100),
              color: Colors.black,
              child: Center(
                child: SizedBox(
                  child: Shimmer.fromColors(
                    baseColor: Colors.red,
                    highlightColor: Colors.yellow,
                    child: Text(
                      'Loading',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: wp(8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            //LOGIN
            return SafeArea(
              child: Container(
                height: hp(100),
                width: wp(100),
                color: kwhitecolor,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: isKeyboardVisible == true ? -hp(22) : 0,
                      right: isKeyboardVisible == true ? -wp(10) : 0,
                      child: ClipPath(
                        child: Container(
                          height: hp(60),
                          width: wp(100),
                          color: kbluelogincolor,
                        ),
                        clipper: CustomClipPathBlue(),
                      ),
                    ),
                    Positioned(
                      top: isKeyboardVisible == true ? -hp(24) : 0,
                      child: ClipPath(
                        child: Container(
                          height: hp(50),
                          width: wp(100),
                          color: kdarklogincolor,
                        ),
                        clipper: CustomClipPathDark(),
                      ),
                    ),
                    Positioned(
                      right: isKeyboardVisible == true ? wp(30) : wp(20),
                      child: ClipPath(
                        child: Container(
                          height: hp(20),
                          width: wp(80),
                          color: klightlogincolor,
                        ),
                        clipper: CustomClipPathOrange(),
                      ),
                    ),
                    Positioned(
                      top: hp(10),
                      left: wp(4),
                      child: CircleAvatar(
                        backgroundColor: kdarklogincolor,
                        child: IconButton(
                            iconSize: wp(4),
                            icon: Icon(
                              FontAwesomeIcons.info,
                              color: kwhitecolor,
                            ),
                            onPressed: () =>
                                context.bloc<AuthBloc>().add(LoginToIntro())),
                      ),
                    ),
                    Positioned(
                      top: hp(3),
                      left: wp(4),
                      child: CircleAvatar(
                        backgroundColor: kdarklogincolor,
                        child: IconButton(
                            color: kwhitecolor,
                            icon: Icon(
                              Icons.menu,
                              color: kwhitecolor,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text('Please insert your Quiz name'),
                                    content: TextField(
                                        controller: _quiznameController,
                                        onEditingComplete: () {
                                          print('${_quiznameController.text}');
                                          context.bloc<LoginBloc>().add(
                                              SaveQuizname(
                                                  quizname: _quiznameController
                                                      .text));
                                          Navigator.pop(context);
                                        }),
                                  );
                                },
                              );
                            }),
                      ),
                    ),
                    isKeyboardVisible == true
                        ? Container()
                        : Positioned(
                            top: hp(20),
                            left: wp(18),
                            child: Text(
                              'Quiz of\nfeelings',
                              style: TextStyle(
                                  fontFamily: fontSintonyBold,
                                  color: Colors.white,
                                  fontSize: wp(8)),
                            ),
                          ),
                    state is SaveQuiznameSuccess
                        ? isKeyboardVisible == false
                            ? Positioned(
                                top: hp(5),
                                right: wp(8),
                                child: Text(
                                  state.savedQuizname != null
                                      ? 'Quiz Name: ${state.savedQuizname}'
                                      : 'Quiz Name: ',
                                  style: TextStyle(
                                      fontFamily: fontSintonyBold,
                                      fontSize: wp(4),
                                      color: kwhitecolor),
                                ))
                            : Container()
                        : Container(),
                    Positioned(
                      bottom: isKeyboardVisible == true ? hp(10) : hp(35),
                      left: wp(10),
                      right: wp(10),
                      child: Column(
                        children: [
                          TextField(
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            onChanged: (username) {
                              context
                                  .bloc<LoginBloc>()
                                  .add(LoginUsernameChanged(username));
                              context
                                  .bloc<LoginBloc>()
                                  .add(LoadQuizNameEvent());
                            },
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
                            onChanged: (value) {
                              context
                                  .bloc<LoginBloc>()
                                  .add(LoginPasswordChanged(value));
                              context
                                  .bloc<LoginBloc>()
                                  .add(LoadQuizNameEvent());
                            },
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
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
                    Visibility(
                      visible: !isKeyboardVisible,
                      child: Positioned(
                        bottom: isKeyboardVisible == true ? hp(2) : hp(22),
                        left: wp(10),
                        child: Row(children: [
                          Text(
                            'Sign in',
                            style: TextStyle(
                                fontFamily: fontSintonyBold,
                                fontSize: wp(6),
                                color: kdarkprimarycolor),
                          ),
                          SizedBox(
                            width: wp(42),
                          ),
                          GestureDetector(
                            onTap: state.username.invalid == true ||
                                    state.password.invalid == true
                                ? null
                                : () {
                                    _onLoginButtonPressed();
                                    context
                                        .bloc<LoginBloc>()
                                        .add(LoadQuizNameEvent());
                                  },
                            child: ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: state.username.invalid == true ||
                                          state.password.invalid == true
                                      ? Colors.grey
                                      : kdarklogincolor,
                                ),
                                height: hp(8),
                                width: wp(16),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    Visibility(
                      visible: !isKeyboardVisible,
                      child: Positioned(
                        bottom: hp(4),
                        left: wp(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RegisterPage())),
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: wp(4.5),
                                    color: kdarkprimarycolor),
                              ),
                            ),
                            SizedBox(
                              width: wp(28),
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
                                    color: kdarkprimarycolor,
                                    fontSize: wp(4.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Visibility(
                    //   visible: !isKeyboardVisible,
                    //   child: Positioned(
                    //     bottom: hp(8),
                    //     left: wp(24),
                    //     right: wp(24),
                    //     child: ElevatedButton(
                    //         style: ButtonStyle(
                    //             backgroundColor:
                    //                 MaterialStateProperty.all(kdarklogincolor)),
                    //         onPressed: () {
                    //           context.bloc<LoginBloc>().add(LoginWithGoogle());
                    //           context
                    //               .bloc<LoginBloc>()
                    //               .add(LoadQuizNameEvent());
                    //         },
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text(
                    //               'Sign in with Google',
                    //               style: TextStyle(fontFamily: fontSintonyBold),
                    //             ),
                    //             Icon(
                    //               FontAwesomeIcons.google,
                    //               color: kwhitecolor,
                    //               size: wp(4),
                    //             ),
                    //           ],
                    //         )),
                    //   ),
                    // ),
                    Visibility(
                      visible: !isKeyboardVisible,
                      child: Positioned(
                        bottom: hp(12),
                        left: wp(24),
                        right: wp(24),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kdarklogincolor)),
                            onPressed: () {
                              context.bloc<LoginBloc>().add(LoginAnonymusly());
                              context
                                  .bloc<LoginBloc>()
                                  .add(LoadQuizNameEvent());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Sign in Anonymously',
                                  style: TextStyle(fontFamily: fontSintonyBold),
                                ),
                              ],
                            )),
                      ),
                    )
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
