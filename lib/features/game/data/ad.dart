import 'package:equatable/equatable.dart';

import '../../../core/domain/random_generator.dart';
import '../domain/ad_content_generator.dart';

mixin Ad {
  AdType get adType;

  int get points;

  String get uuid;

  int get damage => (points / 2).floor();

  int get healthDamage => 1;
}

enum AdType {
  textAd,
  starterAd,
}

class TextAd extends Equatable with Ad {
  TextAd({this.text = '', this.title = ''}) : uuid = getRandomString(7);

  TextAd.randomized(AdContentGenerator adGenerator)
      : text = adGenerator.generateRandomText(),
        title = adGenerator.generateRandomTitle(),
        uuid = getRandomString(7);

  @override
  final String uuid;
  final String title;
  final String text;

  @override
  int get points => 5;

  @override
  List<Object?> get props => <Object>[
        uuid,
        text,
        title,
      ];

  @override
  AdType get adType => AdType.textAd;
}

///Ad that is shown on start up
class StarterAd with Ad {
  StarterAd() : uuid = getRandomString(7);

  @override
  int get damage => 0;

  @override
  int get points => 0;

  @override
  int get healthDamage => 0;

  @override
  AdType get adType => AdType.starterAd;

  @override
  final String uuid;
}
