import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/bloc/rating/rating_bloc.dart';
import 'package:hr_huntlng/models/quiztest.dart';
import 'package:hr_huntlng/models/rating.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AdminPage extends StatefulWidget {
  final User user;
  final List<RatingData> data;

  AdminPage({this.user, this.data});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with TickerProviderStateMixin {
  List<charts.Series<QuizTest, String>> seriesList = [];
  List<charts.Series<QuizTest, String>> seriesListFeeling = [];
  int sumAttentionDetails = 0;
  int sumInnovation = 0;
  int sumConfidence = 0;
  int sumClientService = 0;
  int sumTeamWork = 0;
  int sumFeelingsBad = 0;
  int sumFeelingsOk = 0;
  int sumFeelingsGood = 0;

  void loadData() {
    widget.data.forEach((element) {
      sumAttentionDetails += element.attentionDetails.toInt();
      sumInnovation += element.innovation.toInt();
      sumConfidence += element.confidence.toInt();
      sumClientService += element.clienteService.toInt();
      sumTeamWork += element.teamWork.toInt();
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

    List<QuizTest> list = [
      QuizTest(
          color: charts.ColorUtil.fromDartColor(Colors.green),
          legend: 'Attention',
          values: sumAttentionDetails),
      QuizTest(
          color: charts.ColorUtil.fromDartColor(Colors.blue),
          legend: 'Innovation',
          values: sumInnovation),
      QuizTest(
          color: charts.ColorUtil.fromDartColor(Colors.yellow),
          legend: 'TeamWork',
          values: sumTeamWork),
      QuizTest(
          color: charts.ColorUtil.fromDartColor(Colors.red),
          legend: 'Confidence',
          values: sumConfidence),
      QuizTest(
          color: charts.ColorUtil.fromDartColor(Colors.orange),
          legend: 'Service',
          values: sumClientService),
    ];

    List<QuizTest> listfeeling = [
      QuizTest(
          color: charts.ColorUtil.fromDartColor(Colors.green),
          legend: 'FeelingOk',
          values: sumFeelingsOk),
      QuizTest(
          color: charts.ColorUtil.fromDartColor(Colors.orange),
          legend: 'FeelingBad',
          values: sumFeelingsBad),
      QuizTest(
          color: charts.ColorUtil.fromDartColor(Colors.redAccent),
          legend: 'FeelingGood',
          values: sumFeelingsGood),
    ];

    seriesList = [
      charts.Series(
        data: list,
        id: 'Quiz of Feeling',
        measureFn: (QuizTest data, index) => data.values,
        domainFn: (QuizTest data, index) => data.legend,
        colorFn: (datum, index) => datum.color,
      ),
    ];

    seriesListFeeling = [
      charts.Series(
        data: listfeeling,
        id: 'Quiz of Feeling',
        measureFn: (QuizTest data, index) => data.values,
        domainFn: (QuizTest data, index) => data.legend,
        colorFn: (datum, index) => datum.color,
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    print('Admin Page');
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    print('DATA admin: ${widget.data}');
    print('DATA admin: ${widget.data[0].feelings}');
    print('$sumFeelingsGood');
    print('$sumFeelingsBad');
    print('$sumFeelingsOk');

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
        body: BlocProvider(
          create: (context) => RatingBloc(QuizLoading())..add(LoadQuizData()),
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                child: Container(
                  height: hp(30),
                  child: Card(
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: BlocBuilder<RatingBloc, RatingState>(
                    builder: (context, state) {
                  if (state is QuizLoading) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is QuizLoaded) {
                    return Container(
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: charts.PieChart(
                                seriesListFeeling,
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
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                }),
              ),
            ],
          ),
        ));
  }
}
