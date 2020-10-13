import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/rating/rating_bloc.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';

// final Firebase app = FirebaseApp(

//      FirebaseOptions(
//       googleAppID: '1:1048262391656:android:8ffbe948fb7a9f95f588dd',
//       apiKey: 'AIzaSyAPhM0lrpenTg0a9Jg0B6L1uhfAm-uqTz0',
//       databaseURL: 'https://huntlng.firebaseio.com'
//     ), name: null
//   );

class RatingPage extends StatelessWidget {
  RatingPage({this.user});

  final User user;

  IconData _selectedIcon;

  double clientService;
  double teamWork;
  double confidence;
  double innovation;
  double attentionDetail;

  @override
  Widget build(BuildContext context) {

    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                iconSize: wp(8),
                color: kaccentcolor,
                icon: Icon(Icons.arrow_back),
                onPressed: () => context.bloc<AuthBloc>().add(UserLoggedOut())),
          ),
          body: SingleChildScrollView(
            child: BlocProvider<RatingBloc>(
              create: (context) => RatingBloc(RatingInitial()),
              child: BlocListener<RatingBloc, RatingState>(
                listener: (context, state) {
                  if (state is QuizSended) {
                    if (Platform.isIOS) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return CupertinoAlertDialog(
                            title: Text('Cuestionario enviado'),
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text('Cuestionario enviado'),
                          );
                        },
                      );
                    }
                  }
                },
                child: BlocBuilder<RatingBloc, RatingState>(
                  builder: (context, state) {
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            _heading(
                                'How do you feel today ${user.displayName}?',
                                wp(6),
                                hp(4)),
                            // _ratingBar(_ratingBarMode),
                            // _rating != null
                            //     ? Text(
                            //         "Rating: ",
                            //         style: TextStyle(fontWeight: FontWeight.bold),
                            //       )
                            //     : Container(),
                            SizedBox(
                              height: hp(3),
                            ),
                            valores(
                                'Servicio al cliente', hp(2), clientService),
                            valores('Trabajo en equipo', hp(2), teamWork),
                            valores('Confidencialidad', hp(2), confidence),
                            valores('Innovacion', hp(2), innovation),
                            valores(
                                'Atencion al detalle', hp(2), attentionDetail),
                            SizedBox(
                              height: hp(3),
                            ),
                            new Container(
                              width: wp(80),
                              height: hp(8),
                              margin: EdgeInsets.only(
                                  left: wp(7), right: wp(7), top: hp(2)),
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                color: kaccentcolor,
                                onPressed: () => context
                                    .bloc<RatingBloc>()
                                    .add(SendQuiz(user.displayName)),
                                child: Text(
                                  "Enviar",
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget valores(String valor, double hp, double value) {
    return BlocBuilder<RatingBloc, RatingState>(
      builder: (context, state) {
        return Container(
            margin: EdgeInsets.only(bottom: hp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      case 'Servicio al cliente':
                        context
                            .bloc<RatingBloc>()
                            .add(ClientServiceEvent(clientService: rating));
                        break;
                      case 'Trabajo en equipo':
                        context
                            .bloc<RatingBloc>()
                            .add(TeamWorkEvent(teamWork: rating));
                        break;
                      case 'Confidencialidad':
                        context
                            .bloc<RatingBloc>()
                            .add(ConfidenceEvent(confidence: rating));
                        break;
                      case 'Innovacion':
                        context
                            .bloc<RatingBloc>()
                            .add(InnovationEvent(innovation: rating));
                        break;
                      case 'Atencion al detalle':
                        context.bloc<RatingBloc>().add(
                            AttentionDetailsEvent(attentionDetails: rating));
                        break;
                      default:
                    }
                  },
                ),
              ],
            ));
      },
    );
  }
}

Widget _heading(String text, double wp, double hp) => Column(
      children: [
        Text(
          text,
          style: TextStyle(
              fontFamily: fontOswaldBold,
              fontSize: wp,
              color: kdarkprimarycolor),
        ),
        SizedBox(
          height: hp,
        ),
      ],
    );
