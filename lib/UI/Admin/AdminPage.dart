import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/rating/rating_bloc.dart';
import 'package:hr_huntlng/models/rating.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';
import 'package:hr_huntlng/repository/rating/rating_service.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';

class AdminPage extends StatelessWidget {
  User user;
  List<RatingData> data;

  AdminPage({this.user, this.data});

  @override
  Widget build(BuildContext context) {
    print('admin page ratingdata: $data');
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    final authService = RepositoryProvider.of<AuthService>(context);
    final ratingService = RepositoryProvider.of<RatingService>(context);
    return Scaffold(
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
        title: Text(
          'Welcome ${user.email}',
          style: TextStyle(
              fontFamily: fontOswaldBold,
              color: kdarkprimarycolor,
              fontSize: wp(5)),
        ),
      ),
      body: Container(
          child: ListView(
        scrollDirection: Axis.vertical,
        children: [
         
          BlocProvider<RatingBloc>(
            create: (context) => RatingBloc(QuizLoading())..add(LoadQuizData()),
            child: BlocBuilder<RatingBloc, RatingState>(builder: (context, state) {
              if (state is QuizLoading) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is QuizLoaded) {
                return  DataTable(
              columns: [
                DataColumn(label: Text('innovation')),
                DataColumn(label: Text('attentionDetails')),
                DataColumn(label: Text('teamWork')),
                DataColumn(label: Text('confidence')),
                DataColumn(label: Text('clienteService')),
              ],
              rows: state.data
                  .map((e) => DataRow(cells: [
                        DataCell(
                          Text('${e.innovation}'),
                        ),
                        DataCell(
                          Text('${e.attentionDetails}'),
                        ),
                        DataCell(
                          Text('${e.teamWork}'),
                        ),
                        DataCell(
                          Text('${e.confidence}'),
                        ),
                        DataCell(
                          Text('${e.clienteService}'),
                        ),
                      ]))
                  .toList());
              }
              return Container();
            }),
          )
        ],
      )),
    );
  }
}
