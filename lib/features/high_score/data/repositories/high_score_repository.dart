import 'package:shared_preferences/shared_preferences.dart';

import '../models/high_score.dart';

class HighScoreRepository {
  HighScoreRepository(this.sharedPreferences);

  static const String HIGH_SCORE_KEY = 'HIGH_SCORE';

  final SharedPreferences sharedPreferences;

  HighScore getHighScore() {
    int? score = sharedPreferences.getInt(HIGH_SCORE_KEY);
    score ??= 0;
    return HighScore(score);
  }

  /// Updates high score when possible
  /// Returns updated highs core or null
  Future<HighScore?> setHighScore(HighScore newHighScore) async {
    assert(newHighScore.score != null);
    final currentHighScore = getHighScore();
    if (newHighScore.graterThan(currentHighScore)) {
      sharedPreferences.setInt(HIGH_SCORE_KEY, newHighScore.score);
      return newHighScore;
    }
    return null;
  }

  Future<HighScore> resetHighScore() async {
    await sharedPreferences.setInt(HIGH_SCORE_KEY, 0);
    return const HighScore(0);
  }
}
