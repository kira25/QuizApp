part of 'rating_bloc.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object> get props => [];
}

class ClientServiceEvent extends RatingEvent {
  final double clientService;

  ClientServiceEvent({this.clientService});

  @override
  List<Object> get props => [clientService];
}

class TeamWorkEvent extends RatingEvent {
  final double teamWork;

  TeamWorkEvent({this.teamWork});

  @override
  List<Object> get props => [teamWork];
}

class ConfidenceEvent extends RatingEvent {
  final double confidence;

  ConfidenceEvent({this.confidence});

  @override
  List<Object> get props => [confidence];
}

class InnovationEvent extends RatingEvent {
  final double innovation;

  InnovationEvent({this.innovation});

  @override
  List<Object> get props => [innovation];
}

class AttentionDetailsEvent extends RatingEvent {
  final double attentionDetails;

  AttentionDetailsEvent({this.attentionDetails});

  @override
  List<Object> get props => [attentionDetails];
}

class SendQuiz extends RatingEvent {
  const SendQuiz();
}
