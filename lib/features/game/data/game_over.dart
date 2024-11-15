import 'package:equatable/equatable.dart';

import 'ad.dart';

class GameOver extends Equatable {
  const GameOver({
    required this.points,
    required this.numAds,
    required this.maxNumAds,
    required this.gameOverCause,
    required this.ad,
  });

  final int points;

  // final int timeLeft;
  final int numAds;
  final int maxNumAds;

  //Add that killed player
  final Ad? ad;
  final GameOverCause gameOverCause;

  @override
  List<Object?> get props => [
        points,
        numAds,
        maxNumAds,
        gameOverCause,
        ad,
      ];
}

enum GameOverCause {
  zeroHealth,
  tooManyAds,
}
