import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/UI/Login/LoginPage.dart';
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
  RatingPage({this.user, this.emotion});

  final User user;
  final String emotion;
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

    print(emotion);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocProvider<RatingBloc>(
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  });
                }
              }
            },
            child: BlocBuilder<RatingBloc, RatingState>(
              builder: (context, state) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(wp(6)),
                      child: Row(
                        children: [
                          IconButton(
                              iconSize: wp(8),
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () => Navigator.pop(context))
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
                            .add(SendQuiz(user.displayName)),
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
                );
              },
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
}
