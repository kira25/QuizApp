part of 'rating_bloc.dart';

class RatingState extends Equatable {
  const RatingState(
      {this.attentionDetails,
      this.innovation,
      this.confidence,
      this.teamWork,
      this.clientService});

  final double attentionDetails;
  final double innovation;
  final double confidence;
  final double teamWork;
  final double clientService;

  RatingState copyWith(
      {attentionDetails, innovation, confidence, teamWork, clientService}) {
    return RatingState(
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