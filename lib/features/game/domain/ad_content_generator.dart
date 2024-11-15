import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../core/domain/random_generator.dart';
import '../data/models.dart';

class AdGenerator {
  AdGenerator(this.adContentGenerator);

  static const MIN_AD_GENERATION_TIME_MS = 1;
  static const MAX_AD_GENERATION_TIME_MS = 3000;

  final AdContentGenerator adContentGenerator;

  Timer? _addAdTimer;
  Timer? _reduceGenerationIntervalTimer;

  ///Max time for generating current ad
  int _adGenerationTime = MAX_AD_GENERATION_TIME_MS;

  void _reduceGenerationInterval() {
    _reduceGenerationIntervalTimer = Timer(const Duration(seconds: 1), () {
      if (_adGenerationTime > 1900) {
        _adGenerationTime -= 50;
      } else if (_adGenerationTime > 1400) {
        _adGenerationTime -= 15;
      } else if (_adGenerationTime > 900) {
        _adGenerationTime -= 10;
      } else if (_adGenerationTime > 400) {
        _adGenerationTime -= 5;
      }
      _reduceGenerationInterval();
    });
  }

  final PublishSubject<Ad> $generatedAd = PublishSubject();

  void startGeneratingAds() {
    final int adTimeMs =
        getRandomInt(min: MIN_AD_GENERATION_TIME_MS, max: _adGenerationTime);
    _addAdTimer = Timer(Duration(milliseconds: adTimeMs), () {
      $generatedAd.add(TextAd.randomized(adContentGenerator));
      startGeneratingAds();
      if (_reduceGenerationIntervalTimer == null) {
        _reduceGenerationInterval();
      }
    });
  }

  void stopGeneratingAds() {
    _addAdTimer?.cancel();
    _reduceGenerationIntervalTimer?.cancel();
    _reduceGenerationIntervalTimer = null;
    _adGenerationTime = MAX_AD_GENERATION_TIME_MS;
  }
}

class AdContentGenerator {
  static const List<String> AD_TITLES = [
    'Attention',
    'You will not believe your eyes',
    'Warning',
    'Watch out',
  ];

  static const List<String> AD_TEXT_FIRST = [
    'Horny',
    'Corrupt',
    'Crazy',
    'Drunk',
    'Honest',
    'Fat',
    'Underage',
    'Young',
    'Old',
    'Poor',
    'Handsome',
  ];

  static const List<String> AD_TEXT_SECOND = [
    'moms',
    'politicians',
    'dogs',
    'cats',
    'policeman',
    'firefighter',
    'you mother',
    'truck driver',
    'step mother',
    'step sister',
    'florida man',
    'man',
    'woman',
    'Google CEO',
    'Facebook CEO',
  ];

  static const List<String> AD_TEXT_THIRD = [
    'want to have sex',
    'won the nobel prize',
    'won the election',
    'bite the kid',
    'give money to the poor',
  ];

  static const List<String> AD_SUFFIX = [
    '[NOBODY EXPECTED THAT]',
    '[You will not believe what happened next]',
  ];

  String generateRandomTitle() {
    return AD_TITLES[getRandomInt(max: AD_TITLES.length - 1)];
  }

  ///Text is going to be randomly created from parts
  String generateRandomText() {
    final firstPart = getRandomValueFromList(AD_TEXT_FIRST);
    final secondPart = getRandomValueFromList(AD_TEXT_SECOND);
    final thirdPart = getRandomValueFromList(AD_TEXT_THIRD);
    //Suffix like "NOBODY EXPECTED THAT" can be added to any ad
    String adSuffix = '';
    final bool addAdSuffix = getRandomInt(max: 4) == 0;
    if (addAdSuffix) {
      adSuffix += '\n';
      adSuffix += getRandomValueFromList(AD_SUFFIX);
    }
    return '$firstPart $secondPart $thirdPart $adSuffix';
  }
}
