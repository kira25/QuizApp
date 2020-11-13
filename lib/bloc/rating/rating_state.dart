part of 'rating_bloc.dart';

class RatingState extends Equatable {
  const RatingState(
      {this.attentionDetails = 3.0,
      this.seriesList,
      this.seriesListFeeling,
      this.feelings = 'Bad',
      this.innovation = 3.0,
      this.confidence = 3.0,
      this.teamWork = 3.0,
      this.clientService = 3.0,
      this.event,
      this.loadingResults = false});

  final double attentionDetails;
  final double innovation;
  final double confidence;
  final double teamWork;
  final double clientService;
  final String feelings;
  final List<charts.Series<QuizTest, String>> seriesList;
  final List<charts.Series<QuizTest, String>> seriesListFeeling;
  final Stream<Event> event;
  final bool loadingResults;

  RatingState copyWith(
      {attentionDetails,
      innovation,
      confidence,
      teamWork,
      clientService,
      feelings,
      seriesList,
      seriesListFeeling,
      event,
      loadingResults}) {
    return RatingState(
        feelings: feelings ?? this.feelings,
        attentionDetails: attentionDetails ?? this.attentionDetails,
        innovation: innovation ?? this.innovation,
        confidence: confidence ?? this.confidence,
        teamWork: teamWork ?? this.teamWork,
        clientService: clientService ?? this.clientService,
        seriesList: seriesList ?? this.seriesList,
        seriesListFeeling: seriesListFeeling ?? this.seriesListFeeling,
        loadingResults: loadingResults ?? this.loadingResults);
  }

  @override
  List<Object> get props =>
      [attentionDetails, innovation, confidence, teamWork, clientService];
}

class RatingInitial extends RatingState {}

class QuizSended extends RatingState {}

class QuizLoading extends RatingState {
  @override
  List<Object> get props => [];
}

class LoadQuizResults extends RatingState {
  final bool loading;

  LoadQuizResults({this.loading = false});
}
