import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';

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
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      context.bloc<AuthBloc>().add(UserLoggedOut());
                    }),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 1.0,
                    ),
                    _heading('How do you feel today?'),
                    _ratingBar(_ratingBarMode),
                    SizedBox(
                      height: 20.0,
                    ),
                    // _rating != null
                    //     ? Text(
                    //         "Rating: $_rating",
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       )
                    //     : Container(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Valores('Servicio al cliente'),
                    Valores('Trabajo en equipo'),
                    Valores('Confidencialidad'),
                    Valores('Innovacion'),
                    Valores('Atencion al detalle'),
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
    );
  }

  Widget Valores(String valor) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(valor),
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
      ),
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

Widget _heading(String text) => Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 24.0,
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
      ],
    );
