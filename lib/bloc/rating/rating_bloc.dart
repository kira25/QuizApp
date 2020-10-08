import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';
import 'package:hr_huntlng/repository/rating/rating_service.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc({RatingService ratingService, AuthService authService})
      : assert(ratingService != null),
        assert(authService != null),
        _ratingService = ratingService,
        _authService = authService,
        super(RatingInitial());

  final RatingService _ratingService;
  final AuthService _authService;

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

  Stream<RatingState> _mapSendQuiz(SendQuiz event, RatingState state) async* {
    yield QuizSended();
    User user = _authService.getCurrentuser();

    _ratingService.createData(user.uid, state.clientService, state.teamWork,
        state.confidence, state.innovation, state.attentionDetails);
  }
}
