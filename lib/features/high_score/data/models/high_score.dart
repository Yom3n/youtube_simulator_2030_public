import 'package:equatable/equatable.dart';

class HighScore extends Equatable {
  const HighScore(this.score);

  final int score;

  @override
  List<Object?> get props => [score];

  bool graterThan(HighScore other) {
    return score > other.score;
  }
}
