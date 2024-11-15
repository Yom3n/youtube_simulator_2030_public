import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/high_score.dart';
import '../../data/repositories/high_score_repository.dart';

class HighScoreCubit extends Cubit<HighScoreState> {
  HighScoreCubit(this.highScoreRepository)
      : super(const HighScoreState(HighScore(0), HighScoreStatus.initial));

  final HighScoreRepository highScoreRepository;

  void initialise() {
    final hs = highScoreRepository.getHighScore();
    emit(state.copyWith(highScore: hs, status: HighScoreStatus.loaded));
  }

  Future<void> updateHighScore(int score) async {
    final updatedHighScore =
        await highScoreRepository.setHighScore(HighScore(score));
    if (updatedHighScore?.score != null) {
      emit(state.copyWith(
          highScore: updatedHighScore, status: HighScoreStatus.newRecord));
    } else {
      emit(state.copyWith(
          highScore: highScoreRepository.getHighScore(),
          status: HighScoreStatus.loaded));
    }
  }
}

enum HighScoreStatus { initial, loaded, newRecord }

class HighScoreState extends Equatable {
  const HighScoreState(this.highScore, this.status);

  final HighScore highScore;
  final HighScoreStatus status;

  @override
  List<Object?> get props => [highScore, status];

  HighScoreState copyWith({HighScore? highScore, HighScoreStatus? status}) {
    return HighScoreState(highScore ?? this.highScore, status ?? this.status);
  }
}
