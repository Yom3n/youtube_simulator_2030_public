import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models.dart';
import '../../../domain/game_manager.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit(this.gameManager)
      : super(PlayerState(
          gameManager.$player.value.healthPoints,
          gameManager.$player.value.points,
        )) {
    gameManager.$player.listen(_onPlayerDataChanged);
  }

  final GameManager gameManager;

  void iDamagePlayer(Ad ad) {
    gameManager.hitAdBody(ad);
  }

  void _onPlayerDataChanged(Player player) {
    final actualHp = player.healthPoints;
    if (state.health > actualHp) {
      emit(PlayerStateHit(actualHp, gameManager.$player.value.points));
    } else {
      emit(PlayerState(actualHp, gameManager.$player.value.points));
    }
  }
}

class PlayerState extends Equatable {
  const PlayerState(this.health, this.points);

  final int health;
  final int points;

  @override
  List<Object?> get props => [health, points];
}

class PlayerStateHit extends PlayerState {
  const PlayerStateHit(int health, int points) : super(health, points);
}
