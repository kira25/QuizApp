import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hr_huntlng/models/quiztest.dart';
import 'package:hr_huntlng/models/rating.dart';
import 'package:hr_huntlng/repository/preferences/preferences_repository.dart';
import 'package:hr_huntlng/repository/rating/rating_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc(
    RatingState initialState,
  ) : super(initialState);

  PreferenceRepository _preferenceRepository = PreferenceRepository();
  RatingService _ratingService = RatingService();
  int sumAttentionDetails = 0;
  int sumInnovation = 0;
  int sumConfidence = 0;
  int sumClientService = 0;
  int sumTeamWork = 0;
  int sumFeelingsBad = 0;
  int sumFeelingsOk = 0;
  int sumFeelingsGood = 0;

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
      yield* _mapLoadQuizData(event, state);
    }
  }

  Stream<RatingState> _mapLoadQuizData(
      LoadQuizData event, RatingState state) async* {
    var databaseOnValue = await _ratingService.readData();
    if (await databaseOnValue.isEmpty == true) {
      yield LoadQuizResults(loading: false);
    } else {
      yield LoadQuizResults(loading: true);
    }
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
