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
  List<RatingData> data;

  AdminPage({this.user, this.data});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with TickerProviderStateMixin {
  List<charts.Series<QuizTest, String>> seriesList = [];
  int sumAttentionDetails = 0;
  int sumInnovation = 0;
  int sumConfidence = 0;
  int sumClientService = 0;
  int sumTeamWork = 0;
  bool animate;

  void loadData() {
    widget.data
        .forEach((element) => sumAttentionDetails += element.attentionDetails);
    widget.data.forEach((element) => sumInnovation += element.innovation);
    widget.data.forEach((element) => sumConfidence += element.confidence);
    widget.data
        .forEach((element) => sumClientService += element.clienteService);
    widget.data.forEach((element) => sumTeamWork += element.teamWork);
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

    seriesList = [
      charts.Series(
        data: list,
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
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    print('DATA admin: ${widget.data}');

    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              iconSize: wp(8),
              color: kaccentcolor,
              icon: Icon(Icons.arrow_back),
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
                    );
                  }
                  return Container();
                }),
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
