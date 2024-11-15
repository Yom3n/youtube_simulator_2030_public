import 'package:audioplayers/audioplayers.dart';

import '../data/assets.dart';
import 'random_generator.dart';

///Singleton audio player
class MyAudioPlayer {
  factory MyAudioPlayer() {
    final _audioCache = AudioCache();
    _myAudioPlayer ??= MyAudioPlayer._internal(_audioCache);

    return _myAudioPlayer!;
  }

  MyAudioPlayer._internal(this._audioCache);

  static MyAudioPlayer? _myAudioPlayer;
  late final AudioCache _audioCache;

  Future<AudioPlayer> playLoopedMainMenuMusic() async {
    return _audioCache.loop(SoundAssets.machineConfronationSong);
  }

  Future<void> playAdPopUpSound() => _audioCache.play(SoundAssets.popUp);

  ///Plays when player slains the ad by taping X button
  Future<AudioPlayer> playAdSlainSound() async {
    final bool playEasterEggSound = getRandomInt(max: 200) == 0;
    if (playEasterEggSound) {
      return _audioCache.play(SoundAssets.wilhelmScream);
    } else {
      return _audioCache.play(getRandomValueFromList(SoundAssets.DEATH_SOUNDS));
    }
  }

  ///Plays when player hits ad body
  Future<AudioPlayer> playAdMissedSound() async {
    return _audioCache.play(getRandomValueFromList(SoundAssets.OUCH_SOUNDS));
  }
}
