import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_huntlng/models/rating.dart';
import 'package:hr_huntlng/repository/preferences/preferences_repository.dart';
import 'package:hr_huntlng/repository/rating/rating_service.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc(
    RatingState initialState,
  ) : super(initialState);

  PreferenceRepository _preferenceRepository = PreferenceRepository();
  RatingService _ratingService = RatingService();

  @override
  Stream<RatingState> mapEventToState(
    RatingEvent event,
  ) async* {
    if (event is SendQuiz) {
      yield* _mapSendQuiz(event, state);
    } else if (event is ClientServiceEvent) {
      yield _mapClientServiceEvent(event, state);
    } else if (event is TeamWorkEvent) {
      yield _mapTeamWorkEvent(event, state);
    } else if (event is ConfidenceEvent) {
      yield _mapConfidenceEvent(event, state);
    } else if (event is InnovationEvent) {
      yield _mapInnovationEvent(event, state);
    } else if (event is AttentionDetailsEvent) {
      yield _mapAttentionDetailsEvent(event, state);
    } else if (event is FeelingsEvent) {
      yield _mapFeelingsEvent(event, state);
    } else if (event is LoadQuizData) {
      yield* _mapLoadQuizData();
    }
  }

  Stream<RatingState> _mapLoadQuizData() async* {
    
    List<RatingData> data = await _ratingService.readData();
    yield QuizLoaded(data: data);
  }

  RatingState _mapClientServiceEvent(
      ClientServiceEvent event, RatingState state) {
    print('ServiceEvent');

    return state.copyWith(clientService: event.clientService);
  }

  RatingState _mapTeamWorkEvent(TeamWorkEvent event, RatingState state) {
    print('TeamWorkEvent');

    return state.copyWith(teamWork: event.teamWork);
  }

  RatingState _mapConfidenceEvent(ConfidenceEvent event, RatingState state) {
    print('ConfidenceEvent');

    return state.copyWith(confidence: event.confidence);
  }

  RatingState _mapInnovationEvent(InnovationEvent event, RatingState state) {
    print('InnovationEvent');

    return state.copyWith(innovation: event.innovation);
  }

  RatingState _mapAttentionDetailsEvent(
      AttentionDetailsEvent event, RatingState state) {
    print('AttentionDetailsEvent');

    return state.copyWith(attentionDetails: event.attentionDetails);
  }

  RatingState _mapFeelingsEvent(FeelingsEvent event, RatingState state) {
    print('FeelingEvents');

    return state.copyWith(feelings: event.feelings);
  }

  Stream<RatingState> _mapSendQuiz(SendQuiz event, RatingState state) async* {
    String quizname = await _preferenceRepository.getData('data');
    yield QuizSended();

    _ratingService.createData(
        quizname,
        event.displayName,
        state.feelings,
        state.clientService,
        state.teamWork,
        state.confidence,
        state.innovation,
        state.attentionDetails);
    print('Send data quiz');
  }
}
