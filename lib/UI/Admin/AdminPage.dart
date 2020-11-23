import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/rating/rating_bloc.dart';
import 'package:hr_huntlng/models/quiztest.dart';
import 'package:hr_huntlng/models/rating.dart';
import 'package:hr_huntlng/repository/preferences/preferences_repository.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AdminPage extends StatefulWidget {
  final User user;

  AdminPage({
    this.user,
  });

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with TickerProviderStateMixin {
  PreferenceRepository _preferenceRepository = PreferenceRepository();
  final databaseReference = FirebaseDatabase.instance.reference();
  List<RatingData> list2 = [];
  String quizname;
  DatabaseReference _firebaseRef;

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();

    print('Admin Page');
  }

  loadData() async {
    quizname = await _preferenceRepository.getData('data');
    setState(() {
      _firebaseRef = databaseReference.child(quizname);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;

    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              iconSize: wp(8),
              color: kdarklogincolor,
              icon: Icon(Icons.close),
              onPressed: () {
                context.bloc<AuthBloc>().add(UserLoggedOut());
              }),
          bottom: TabBar(controller: _tabController, tabs: [
            Tab(
              icon: Icon(
                FontAwesomeIcons.solidChartBar,
                color: kdarkprimarycolor,
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.chartPie,
                color: kdarkprimarycolor,
              ),
            ),
          ]),
          title: Text(
            'Welcome Admin',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: fontOswaldBold,
                color: kdarkprimarycolor,
                fontSize: wp(5)),
          ),
        ),
        body: BlocProvider<RatingBloc>(
          create: (context) => RatingBloc(RatingInitial())..add(LoadQuizData()),
          child: BlocBuilder<RatingBloc, RatingState>(
            builder: (context, state) {
              if (state is LoadQuizResults) {
                if (state.loading == false) {
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      Container(
                          child: StreamBuilder(
                        stream: _firebaseRef.onValue,
                        builder: (context, AsyncSnapshot<Event> snapshot) {
                          if (snapshot.hasData) {
                            int sumAttentionDetails = 0;
                            int sumInnovation = 0;
                            int sumConfidence = 0;
                            int sumClientService = 0;
                            int sumTeamWork = 0;

                            DataSnapshot dataValues = snapshot.data.snapshot;
                            Map data = dataValues.value;

                            var data2 = data.values.toList();
                            list2 = data2
                                .map((e) => RatingData.fromJson(e))
                                .toList();

                            list2.forEach((element) {
                              sumAttentionDetails +=
                                  element.attentionDetails.toInt();
                              sumInnovation += element.innovation.toInt();
                              sumConfidence += element.confidence.toInt();
                              sumClientService +=
                                  element.clienteService.toInt();
                              sumTeamWork += element.teamWork.toInt();
                            });
                            List<QuizTest> list = [
                              QuizTest(
                                  color: charts.ColorUtil.fromDartColor(
                                      Colors.green),
                                  legend: 'Attention',
                                  values: sumAttentionDetails),
                              QuizTest(
                                  color: charts.ColorUtil.fromDartColor(
                                      Colors.blue),
                                  legend: 'Innovation',
                                  values: sumInnovation),
                              QuizTest(
                                  color: charts.ColorUtil.fromDartColor(
                                      Colors.yellow),
                                  legend: 'TeamWork',
                                  values: sumTeamWork),
                              QuizTest(
                                  color: charts.ColorUtil.fromDartColor(
                                      Colors.red),
                                  legend: 'Confidence',
                                  values: sumConfidence),
                              QuizTest(
                                  color: charts.ColorUtil.fromDartColor(
                                      Colors.orange),
                                  legend: 'Service',
                                  values: sumClientService),
                            ];

                            List<charts.Series<QuizTest, String>> seriesList = [
                              charts.Series(
                                data: list,
                                id: 'Quiz of Feeling',
                                measureFn: (QuizTest data, index) =>
                                    data.values,
                                domainFn: (QuizTest data, index) => data.legend,
                                colorFn: (datum, index) => datum.color,
                              ),
                            ];

                            return Container(
                              child: charts.BarChart(
                                seriesList,
                                animate: true,
                                behaviors: [
                                  charts.DatumLegend(
                                    position: charts.BehaviorPosition.bottom,
                                    horizontalFirst: false,
                                    showMeasures: true,
                                    legendDefaultMeasure:
                                        charts.LegendDefaultMeasure.firstValue,
                                    measureFormatter: (measure) {
                                      return measure == null ? '-' : '$measure';
                                    },
                                  )
                                ],
                              ),
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      )),
                      Container(
                        child: StreamBuilder(
                            stream: _firebaseRef.onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                DataSnapshot dataValues =
                                    snapshot.data.snapshot;
                                Map data = dataValues.value;
                                int sumFeelingsBad = 0;
                                int sumFeelingsOk = 0;
                                int sumFeelingsGood = 0;
                                var data2 = data.values.toList();
                                list2 = data2
                                    .map((e) => RatingData.fromJson(e))
                                    .toList();

                                list2.forEach((element) {
                                  if (element.feelings == "Ok") {
                                    sumFeelingsOk++;
                                  } else if (element.feelings == "Bad") {
                                    sumFeelingsBad++;
                                  } else if (element.feelings == "Good") {
                                    sumFeelingsGood++;
                                  } else {
                                    return null;
                                  }
                                });

                                List<QuizTest> listfeeling = [
                                  QuizTest(
                                      color: charts.ColorUtil.fromDartColor(
                                          Colors.orange),
                                      legend: 'Ok',
                                      values: sumFeelingsOk),
                                  QuizTest(
                                      color: charts.ColorUtil.fromDartColor(
                                          Colors.redAccent),
                                      legend: 'Bad',
                                      values: sumFeelingsBad),
                                  QuizTest(
                                      color: charts.ColorUtil.fromDartColor(
                                          Colors.green),
                                      legend: 'Good',
                                      values: sumFeelingsGood),
                                ];
                                List<charts.Series<QuizTest, String>>
                                    seriesListFeeling = [
                                  charts.Series(
                                    data: listfeeling,
                                    id: 'Quiz of Feeling',
                                    measureFn: (QuizTest data, index) =>
                                        data.values,
                                    domainFn: (QuizTest data, index) =>
                                        data.legend,
                                    colorFn: (datum, index) => datum.color,
                                  ),
                                ];
                                return Container(
                                  child: charts.PieChart(
                                    seriesListFeeling,
                                    animate: true,
                                    behaviors: [
                                      charts.DatumLegend(
                                        position:
                                            charts.BehaviorPosition.bottom,
                                        horizontalFirst: false,
                                        showMeasures: true,
                                        legendDefaultMeasure: charts
                                            .LegendDefaultMeasure.firstValue,
                                        measureFormatter: (measure) {
                                          return measure == null
                                              ? '-'
                                              : '$measure';
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            }),
                      ),
                    ],
                  );
                }
              }
              return Container();
            },
          ),
        ));
  }
}
