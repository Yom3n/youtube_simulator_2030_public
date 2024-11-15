import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models.dart';
import '../../../domain/game_manager.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this.gameManager) : super(GameStateInitial([StarterAd()])) {
    gameManager.$ads.listen(_onAdsUpdated);
    gameManager.$gameOver.listen(_onGameOver);
  }

  final GameManager gameManager;

  void iGameStarted() {
    emit(const GameStateIdle([]));
    gameManager.startGame();
  }

  void iGameStopped() {
    gameManager.stopGame();
  }

  void iAdKilled(Ad ad) {
    if (state is GameStateInitial && ad.adType == AdType.starterAd) {
      iGameStarted();
      return;
    }
    gameManager.killAd(ad);
  }

  @mustCallSuper
  void dispose() {
    gameManager.dispose();
  }

  void _onAdsUpdated(List<Ad> ads) {
    emit(
      GameStateIdle(ads.toList()),
    );
  }

  void _onGameOver(GameOver? gameOver) {
    if (gameOver != null) {
      iGameStopped();
      emit(GameStateGameOver(gameOver: gameOver));
    }
  }

  @override
  Future<void> close() {
    gameManager.dispose();
    return super.close();
  }
}

abstract class GameState extends Equatable {
  const GameState(
    this.activeAds,
  );

  final List<Ad> activeAds;

  @override
  List<Object?> get props => [activeAds];
}

class GameStateInitial extends GameState {
  const GameStateInitial(List<Ad> activeAds)
      : super(
          activeAds,
        );
}

class GameStateIdle extends GameState {
  const GameStateIdle(List<Ad> activeAds) : super(activeAds);
}

class GameStateGameOver extends GameState {
  const GameStateGameOver({
    required this.gameOver,
    List<TextAd> activeAds = const [],
  }) : super(activeAds);

  final GameOver gameOver;

  @override
  List<Object?> get props => super.props..add(gameOver);
}
