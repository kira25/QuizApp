part of 'rating_bloc.dart';

class RatingState extends Equatable {
  const RatingState(
      {this.attentionDetails,
      this.feelings,
      this.innovation,
      this.confidence,
      this.teamWork,
      this.clientService});

  final double attentionDetails;
  final double innovation;
  final double confidence;
  final double teamWork;
  final double clientService;
  final String feelings;

  RatingState copyWith(
      {attentionDetails,
      innovation,
      confidence,
      teamWork,
      clientService,
      feelings}) {
    return RatingState(
      feelings: feelings ?? this.feelings,
      attentionDetails: attentionDetails ?? this.attentionDetails,
      innovation: innovation ?? this.innovation,
      confidence: confidence ?? this.confidence,
      teamWork: teamWork ?? this.teamWork,
      clientService: clientService ?? this.clientService,
    );
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

class QuizLoaded extends RatingState {
  final List<RatingData> data;

  QuizLoaded({this.data});
  @override
  List<Object> get props => [data];
}
