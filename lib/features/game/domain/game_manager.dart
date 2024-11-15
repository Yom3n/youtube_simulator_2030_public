import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../data/models.dart';
import 'ad_content_generator.dart';
import 'points_counter.dart';

///Game ends when there will be more than this number of ads on the screen
const int NUM_ADS_LIMIT = 30;

class GameManager {
  GameManager({
    required this.adGenerator,
  }) {
    $player.add(Player.defaultPlayer(pointCounter: PointCounter()));
    _generatedAdSubscription = adGenerator.$generatedAd.listen(_onGeneratedAd);
  }

  late final StreamSubscription<Ad> _generatedAdSubscription;

  final AdGenerator adGenerator;

  final BehaviorSubject<List<Ad>> $ads = BehaviorSubject();

  final BehaviorSubject<Player> $player = BehaviorSubject();

  final PublishSubject<GameOver?> $gameOver = PublishSubject();

  void startGame() {
    $gameOver.add(null);
    $player.add(Player.defaultPlayer(pointCounter: PointCounter()));
    adGenerator.startGeneratingAds();
  }

  void stopGame() {
    $ads.add([]);
    adGenerator.stopGeneratingAds();
  }

  void killAd(Ad ad) {
    Player player = $player.value;
    player = player.adKilled(ad);
    $player.add(player);
    final updatedAds = $ads.value..remove(ad);
    $ads.add(updatedAds);
  }

  void hitAdBody(Ad ad) {
    Player player = $player.value;
    player = player.hitPlayer(ad);
    $player.add(player);
    if (player.isDead) {
      $gameOver.add(GameOver(
          points: player.points,
          numAds: $ads.value.length,
          maxNumAds: NUM_ADS_LIMIT,
          gameOverCause: GameOverCause.zeroHealth,
          ad: ad));
    }
  }

  @mustCallSuper
  void dispose() {
    $ads.close();
    adGenerator.stopGeneratingAds();
    _generatedAdSubscription.cancel();
  }

  void _onGeneratedAd(Ad newAd) {
    final initialAds = $ads.valueOrNull ?? [];
    final updatedAds = initialAds..add(newAd);
    $ads.add(List.from(updatedAds));
    if (updatedAds.length > NUM_ADS_LIMIT) {
      $gameOver.add(GameOver(
          points: $player.value.points,
          numAds: $ads.value.length,
          maxNumAds: NUM_ADS_LIMIT,
          gameOverCause: GameOverCause.tooManyAds,
          ad: null));
    }
  }
}
