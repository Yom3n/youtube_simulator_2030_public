import '../data/models.dart';

class PointCounter {
  int _points = 0;

  void addPointsForClosedAd(Ad ad) {
    _points += ad.points;
  }

  void playerDamaged(int damage) {
    if (_points - damage < 0) {
      _points = 0;
    } else {
      _points -= damage;
    }
  }

  int get points => _points;
}
