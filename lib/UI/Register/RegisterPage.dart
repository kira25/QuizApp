import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hr_huntlng/UI/Admin/AdminPage.dart';
import 'package:hr_huntlng/UI/Login/LoginPage.dart';
import 'package:hr_huntlng/UI/Quiz/QuizPage.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/login/login_bloc.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:shimmer/shimmer.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return KeyboardVisibilityProvider(
      child: RegisterForm(hp: hp, wp: wp),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key key,
    @required this.hp,
    @required this.wp,
  }) : super(key: key);

  final Function hp;
  final Function wp;

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      body: CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        painter: BackGround(),
        child: BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(context.bloc<AuthBloc>()),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthenticationAuthenticated) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizPage(
                                user: state.user,
                              )));
                } else if (state is AuthenticationNotAuthenticated) {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } else if (state is AuthenticationAdmin) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AdminPage(user: state.user, data: state.data)));
                }
              },
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is RegisterLoading) {
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
                  }
                  return SafeArea(
                    child: Container(
                      height: hp(100),
                      width: wp(100),
                      padding: EdgeInsets.all(wp(3)),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: hp(2)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios),
                                      color: kwhitecolor,
                                      iconSize: wp(8),
                                      onPressed: () => Navigator.pop(context)),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text('Create Account',
                                      style: TextStyle(
                                          fontFamily: fontOswaldBold,
                                          fontSize: wp(8),
                                          color: kwhitecolor)),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: isKeyboardVisible == true ? hp(15) : hp(25),
                            left: wp(10),
                            right: wp(10),
                            child: Container(
                              child: Column(
                                children: [
                                  BlocBuilder<LoginBloc, LoginState>(
                                    buildWhen: (previous, current) =>
                                        previous.username != current.username,
                                    builder: (context, state) {
                                      return TextField(
                                        style: TextStyle(
                                            fontFamily: fontSintonyRegular,
                                            color: kwhitecolor,
                                            fontSize: wp(4.5)),
                                        autofocus: false,
                                        key: const Key(
                                            'loginForm_usernameInput_textField'),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onChanged: (username) => context
                                            .bloc<LoginBloc>()
                                            .add(
                                                LoginUsernameChanged(username)),
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: wp(0.5),
                                                  color: kwhitecolor)),
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
                                          hintStyle:
                                              TextStyle(color: kwhitecolor),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: hp(5),
                                  ),
                                  BlocBuilder<LoginBloc, LoginState>(
                                    buildWhen: (previous, current) =>
                                        previous.password != current.password,
                                    builder: (context, state) {
                                      return TextField(
                                        style: TextStyle(
                                            fontFamily: fontSintonyRegular,
                                            color: kwhitecolor,
                                            fontSize: wp(4.5)),
                                        autofocus: false,
                                        obscureText: true,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onChanged: (password) => context
                                            .bloc<LoginBloc>()
                                            .add(
                                                LoginPasswordChanged(password)),
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: wp(0.5),
                                                    color: kwhitecolor)),
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
                                            hintStyle:
                                                TextStyle(color: kwhitecolor),
                                            hintText: 'Password'),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: hp(5),
                                  ),
                                  BlocBuilder<LoginBloc, LoginState>(
                                    buildWhen: (previous, current) =>
                                        previous.displayName !=
                                        current.displayName,
                                    builder: (context, state) {
                                      return TextField(
                                        style: TextStyle(
                                            fontFamily: fontSintonyRegular,
                                            color: kwhitecolor,
                                            fontSize: wp(4.5)),
                                        autofocus: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onChanged: (displayName) => context
                                            .bloc<LoginBloc>()
                                            .add(RegisterDisplayNameChanged(
                                                displayName)),
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: wp(0.5),
                                                    color: kwhitecolor)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: wp(0.5),
                                                    color: kdarkprimarycolor)),
                                            errorStyle: TextStyle(
                                                fontFamily: fontOswaldRegular,
                                                color: kaccentcolor,
                                                fontSize: wp(4)),
                                            hintStyle:
                                                TextStyle(color: kwhitecolor),
                                            hintText: 'Name'),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: hp(15),
                            left: wp(2),
                            right: wp(2),
                            child: Visibility(
                              visible: !isKeyboardVisible,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Sign up',
                                      style: TextStyle(
                                          fontFamily: fontOswaldBold,
                                          fontSize: wp(6),
                                          color: kwhitecolor),
                                    ),
                                    BlocBuilder<LoginBloc, LoginState>(
                                      builder: (context, state) {
                                        return CircleAvatar(
                                          radius: wp(8),
                                          backgroundColor: kdarklogincolor,
                                          child: BlocBuilder<LoginBloc,
                                              LoginState>(
                                            builder: (context, state) {
                                              return IconButton(
                                                onPressed: state.username
                                                                .invalid ==
                                                            true ||
                                                        state.password
                                                                .invalid ==
                                                            true
                                                    ? null
                                                    : () => context
                                                        .bloc<LoginBloc>()
                                                        .add(
                                                            RegisterButtonPressed()),
                                                icon: Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}

class BackGround extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainbackground = Path();
    mainbackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.white;
    canvas.drawPath(mainbackground, paint);

    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.6);
    blueWave.cubicTo(sw * 0.85, sh * 0.75, sw * 0.50, sh * 0.75, sw * 0.3, sh);
    blueWave.lineTo(0, sh);

    blueWave.close();
    paint.color = kbluelogincolor;
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.3);
    greyWave.cubicTo(sw * 0.85, sh * 0.45, sw * 0.20, sh * 0.35, 0, sh * 0.5);
    // greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.6);
    greyWave.close();
    paint.color = kdarklogincolor;
    canvas.drawPath(greyWave, paint);

    // Paint paint = new Paint();
    // paint.color = kdarklogincolor;
    // paint.strokeWidth = 100;
    // paint.isAntiAlias = true;

    // Paint paint2 = new Paint();
    // paint2.color = kbluelogincolor;
    // paint2.strokeWidth = 100;
    // paint2.isAntiAlias = true;

    // canvas.drawLine(
    //     Offset(300, -120), Offset(size.width + 60, size.width - 280), paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
