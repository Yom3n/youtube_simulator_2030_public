import 'package:equatable/equatable.dart';

import '../domain/points_counter.dart';
import 'models.dart';

class Player extends Equatable {
  const Player({
    required this.healthPoints,
    required this.pointCounter,
  });

  const Player.defaultPlayer(
      {this.healthPoints = 10, required this.pointCounter});

  final int healthPoints;
  final PointCounter pointCounter;

  @override
  List<Object?> get props => [healthPoints];

  bool get isAlive => healthPoints > 0;

  bool get isDead => !isAlive;

  int get points => pointCounter.points;

  Player copy() {
    return Player(
      pointCounter: pointCounter,
      healthPoints: healthPoints,
    );
  }

  Player adKilled(Ad ad) {
    pointCounter.addPointsForClosedAd(ad);
    return Player(
      healthPoints: healthPoints,
      pointCounter: pointCounter,
    );
  }

  Player hitPlayer(Ad ad) {
    pointCounter.playerDamaged(ad.damage);
    int updatedLife = healthPoints - ad.healthDamage;
    if (updatedLife < 0) {
      updatedLife = 0;
    }
    return Player(
      healthPoints: updatedLife,
      pointCounter: pointCounter,
    );
  }
}
