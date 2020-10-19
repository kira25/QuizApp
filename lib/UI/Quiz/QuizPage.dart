import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/rating/rating_bloc.dart';
import 'package:hr_huntlng/commons/SliderPainter.dart';
import 'package:hr_huntlng/utils/backgroundColorTween.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:hr_huntlng/utils/flareController.dart';
import 'package:hr_huntlng/utils/titleFeel.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter_bloc/flutter_bloc.dart';

enum SlideState { Bad, Ok, Good }

class QuizPage extends StatefulWidget {
  final User user;

  const QuizPage({Key key, this.user}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  FlareRateController _flareRateController;
  AnimationController _animationController;
  double _dragPercent = 0.0;
  SlideState slideState = SlideState.Bad;
  IconData _selectedIcon;
  String emotion;
  double clientService;
  double teamWork;
  double confidence;
  double innovation;
  double attentionDetail;
  PageController _controller =
      new PageController(initialPage: 0, viewportFraction: 1.0);

  void updateDragPosition(Offset offset) {
    setState(() {
      _dragPercent = (offset.dx / 340).clamp(0.0, 1.0);
      _flareRateController.updatePercent(_dragPercent);
    });

    if (_dragPercent >= 0 && _dragPercent < .3) {
      slideState = SlideState.Bad;
      _animationController.forward(from: 0.0);
    } else if (_dragPercent >= .3 && _dragPercent < .7) {
      slideState = SlideState.Ok;
      _animationController.stop();
    } else if (_dragPercent > .7) {
      slideState = SlideState.Good;
    }
  }

  Widget dispTitle(double wp) {
    switch (slideState) {
      case SlideState.Bad:
        return chooseTitle(wp, 0);
        break;
      case SlideState.Ok:
        return chooseTitle(wp, 1);
        break;
      case SlideState.Good:
        return chooseTitle(wp, 2);
        break;
      default:
        return null;
    }
  }

  void _onDragStart(BuildContext context, DragStartDetails details) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.localToGlobal(details.globalPosition);
    updateDragPosition(localOffset);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails details) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.localToGlobal(details.globalPosition);
    updateDragPosition(localOffset);
  }

  @override
  void initState() {
    super.initState();
    print('QuizPage');
    _flareRateController = FlareRateController();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _animationController =
        AnimationController(vsync: this, duration: Duration(microseconds: 750))
          ..addListener(() {
            setState(() {});
          });
  }

  _shake() {
    double offset = math.sin(_animationController.value * math.pi * 60.0);
    return vector.Vector3(offset * 2, offset * 2, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return AnimatedContainer(
      duration: Duration(seconds: 1),
      color: backgroundTween.evaluate(AlwaysStoppedAnimation(_dragPercent)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: _controller,
          physics: new AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            BlocProvider<RatingBloc>(
              create: (context) => RatingBloc(RatingInitial()),
              child: BlocBuilder<RatingBloc, RatingState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      _appBar(wp(8), hp(10)),
                      _headerText(wp(5), widget.user.displayName),
                      SizedBox(
                        height: hp(4),
                      ),
                      _title(wp(6)),
                      SizedBox(
                        height: hp(4),
                      ),
                      _flareActor(wp(80), hp(60)),
                      SizedBox(
                        height: hp(4),
                      ),
                      _slider(50, 340),
                      SizedBox(
                        height: hp(7),
                      ),
                      Container(
                        width: wp(80),
                        height: hp(8),
                        margin: EdgeInsets.only(
                            left: wp(7), right: wp(7), top: hp(2)),
                        child: RaisedButton(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: kdarklogincolor,
                          onPressed: () {
                            if (slideState == SlideState.Bad) {
                              emotion = 'Bad';
                              context
                                  .bloc<RatingBloc>()
                                  .add(FeelingsEvent(feelings: emotion));
                              //controller_0To1.forward(from: 0.0);
                              goToRating();
                            } else if (slideState == SlideState.Ok) {
                              emotion = 'Ok';
                              context
                                  .bloc<RatingBloc>()
                                  .add(FeelingsEvent(feelings: emotion));
                              goToRating();
                            } else if (slideState == SlideState.Good) {
                              emotion = 'Good';
                              context
                                  .bloc<RatingBloc>()
                                  .add(FeelingsEvent(feelings: emotion));
                              goToRating();
                            } else {
                              return null;
                            }
                          },
                          child: Text(
                            "Next",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: wp(4),
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            BlocProvider<RatingBloc>(
              create: (context) => RatingBloc(RatingInitial())
                ..add(FeelingsEvent(feelings: emotion)),
              child: BlocListener<RatingBloc, RatingState>(
                listener: (context, state) {
                  if (state is QuizSended) {
                    if (Platform.isIOS) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return CupertinoAlertDialog(
                            title: Center(child: Text('Cuestionario enviado')),
                          );
                        },
                      );
                      Future.delayed(Duration(seconds: 2)).then((value) {
                        context.bloc<AuthBloc>().add(UserLoggedOut());
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text('Cuestionario enviado'),
                          );
                        },
                      );
                      Future.delayed(Duration(seconds: 2)).then((value) {
                        context.bloc<AuthBloc>().add(UserLoggedOut());
                      });
                    }
                  }
                },
                child: BlocBuilder<RatingBloc, RatingState>(
                  builder: (context, state) {
                    return Container(
                      color: kwhitecolor,
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(wp(6)),
                            child: Row(
                              children: [
                                IconButton(
                                    iconSize: wp(8),
                                    icon: Icon(Icons.arrow_back_ios),
                                    onPressed: () => goToPrevious())
                              ],
                            ),
                          ),
                          valores('Client Service', hp(3), clientService),
                          valores('Teamwork', hp(3), teamWork),
                          valores('Confidence', hp(3), confidence),
                          valores('Innovation', hp(3), innovation),
                          valores('Attention Details', hp(3), attentionDetail),
                          SizedBox(
                            height: hp(4),
                          ),
                          new Container(
                            width: wp(80),
                            height: hp(8),
                            margin: EdgeInsets.only(left: wp(7), right: wp(7)),
                            child: new RaisedButton(
                              elevation: 10,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              color: kdarklogincolor,
                              onPressed: () => context
                                  .bloc<RatingBloc>()
                                  .add(SendQuiz(widget.user.displayName)),
                              child: Text(
                                "Send",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: wp(4),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  goToPrevious() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInSine,
    );
  }

  Widget valores(String valor, double hp, double value) {
    return BlocBuilder<RatingBloc, RatingState>(
      builder: (context, state) {
        return Container(
            child: Column(
          children: <Widget>[
            Text(
              valor,
              style: TextStyle(fontFamily: fontOswaldBold, fontSize: hp),
            ),
            SizedBox(
              height: hp,
            ),
            RatingBar(
              initialRating: 3,
              allowHalfRating: true,
              unratedColor: Colors.grey[200],
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 10.0),
              itemBuilder: (context, _) => Icon(
                _selectedIcon ?? Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                switch (valor) {
                  case 'Client Service':
                    context
                        .bloc<RatingBloc>()
                        .add(ClientServiceEvent(clientService: rating));
                    break;
                  case 'Teamwork':
                    context
                        .bloc<RatingBloc>()
                        .add(TeamWorkEvent(teamWork: rating));
                    break;
                  case 'Confidence':
                    context
                        .bloc<RatingBloc>()
                        .add(ConfidenceEvent(confidence: rating));
                    break;
                  case 'Innovation':
                    context
                        .bloc<RatingBloc>()
                        .add(InnovationEvent(innovation: rating));
                    break;
                  case 'Attention Details':
                    context
                        .bloc<RatingBloc>()
                        .add(AttentionDetailsEvent(attentionDetails: rating));
                    break;
                  default:
                }
              },
            ),
            SizedBox(
              height: hp * 0.6,
            )
          ],
        ));
      },
    );
  }

  goToRating() {
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInSine,
    );
  }

  _appBar(double wp, double hp) => Padding(
        padding: EdgeInsets.all(wp * 0.6),
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.close,
                  size: wp,
                ),
                onPressed: () => context.bloc<AuthBloc>().add(UserLoggedOut())),
            SizedBox(
              width: wp * 1.8,
            ),
            Text(
              'Good day',
              style: TextStyle(fontFamily: fontSintonyBold, fontSize: wp),
            ),
          ],
        ),
      );

  _headerText(double wp, String name) => Padding(
        padding: EdgeInsets.symmetric(horizontal: wp),
        child: Text(
          'How do you feel today ?',
          style: TextStyle(fontFamily: fontSintonyBold, fontSize: wp * 1.1),
        ),
      );

  _title(double wp) => AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        var slideAnim = Tween<Offset>(begin: Offset(-2, 0), end: Offset(0, 0))
            .animate(animation);
        return SlideTransition(
          position: slideAnim,
          child: child,
        );
      },
      child: dispTitle(wp));

  _flareActor(double hp, double wp) => Transform(
        transform: Matrix4.translation(_shake()),
        child: SizedBox(
          height: hp,
          width: wp,
          child: FlareActor(
            'assets/face.flr',
            artboard: 'Artboard',
            controller: _flareRateController,
          ),
        ),
      );
  _slider(double hp, double wp) => GestureDetector(
        onHorizontalDragStart: (details) => _onDragStart(context, details),
        onHorizontalDragUpdate: (details) => _onDragUpdate(context, details),
        child: Container(
          width: wp,
          height: hp,
          child: CustomPaint(
            painter: SliderPainter(progress: _dragPercent),
          ),
        ),
      );
}
