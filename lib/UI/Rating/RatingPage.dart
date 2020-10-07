import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';

// final Firebase app = FirebaseApp(

//      FirebaseOptions(
//       googleAppID: '1:1048262391656:android:8ffbe948fb7a9f95f588dd',
//       apiKey: 'AIzaSyAPhM0lrpenTg0a9Jg0B6L1uhfAm-uqTz0',
//       databaseURL: 'https://huntlng.firebaseio.com'
//     ), name: null
//   );

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  //FIREBASE DATABASE
  final notesReference = FirebaseDatabase.instance.reference().child('valores');

  var _ratingController = TextEditingController();

  var _rating = [];

  int _ratingBarMode = 3;
  IconData _selectedIcon;

  @override
  void initState() {
    _ratingController.text = "3.0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => Scaffold(
            body: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                    iconSize: wp(8),
                    color: kaccentcolor,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      context.bloc<AuthBloc>().add(UserLoggedOut());
                    }),
              ),
              body: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      _heading('How do you feel today?', wp(6), hp(4)),
                      _ratingBar(_ratingBarMode),
                      // _rating != null
                      //     ? Text(
                      //         "Rating: $_rating",
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       )
                      //     : Container(),
                      SizedBox(
                        height: hp(3),
                      ),
                      Valores('Servicio al cliente', hp(2)),
                      Valores('Trabajo en equipo', hp(2)),
                      Valores('Confidencialidad', hp(2)),
                      Valores('Innovacion', hp(2)),
                      Valores('Atencion al detalle', hp(2)),
                      SizedBox(height: hp(3),),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          InsertarFirebaseDatabase();
                          print('Se ingresaron los datos');
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget Valores(String valor, double hp) {
    return Container(
      margin: EdgeInsets.only(bottom: hp),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(valor),
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
            print(rating);
          },
        ),
      ],
    ));
  }

  Widget _ratingBar(int mode) {
    String Estado;

    return RatingBar(
      initialRating: 2,
      itemCount: 3,
      itemSize: 50,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            Estado = "Mal";
            return Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.redAccent,
            );
          // case 1:
          //   return Icon(
          //     Icons.sentiment_dissatisfied,
          //     color: Colors.redAccent,
          //   );
          case 1:
            Estado = "Normal";

            return Icon(
              Icons.sentiment_neutral,
              color: Colors.amber,
            );
          case 2:
            Estado = "Bien";

            return Icon(
              Icons.sentiment_satisfied,
              color: Colors.lightGreen,
            );
          // case 4:
          //   return Icon(
          //     Icons.sentiment_very_satisfied,
          //     color: Colors.green,
          //   );
          default:
            return Container();
        }
      },
      onRatingUpdate: (rating) {
        if (rating == 0) {
          _rating[5] = Estado;
        }
      },
    );
  }

  void InsertarFirebaseDatabase() {
    notesReference.push().set({
      'AttentionDetail': _rating[0],
      'ClientService': _rating[1],
      'Confidence': _rating[2],
      'Innovation': _rating[3],
      'TeamWork': _rating[4],
      'Estado': _rating[5],
    }).then((_) {});
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
