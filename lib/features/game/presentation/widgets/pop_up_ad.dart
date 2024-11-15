import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/domain/my_audio_player.dart';
import '../../../../core/domain/random_generator.dart';
import '../../../../core/presentation/colors.dart';
import '../../../../core/presentation/random_position_widget.dart';
import '../../data/models.dart';

class AdBodyGenerator extends StatelessWidget {
  const AdBodyGenerator({
    Key? key,
    required this.ad,
    required this.onCloseTapped,
    required this.onAdBodyTapped,
  }) : super(key: key);

  final Ad ad;
  final Function(Ad) onCloseTapped;
  final Function(Ad)? onAdBodyTapped;

  @override
  Widget build(BuildContext context) {
    switch (ad.adType) {
      case AdType.textAd:
        return TextPopUpAd(
          ad: ad as TextAd,
          onCloseTapped: onCloseTapped,
          onAdBodyTapped: onAdBodyTapped,
        );
      case AdType.starterAd:
        return InitialAd(
          ad: ad as StarterAd,
          onCloseTapped: onCloseTapped,
        );
    }
  }
}

class InitialAd extends StatefulWidget {
  const InitialAd(
      {required this.ad,
      required this.onCloseTapped,
      this.onBodyTapped,
      Key? key})
      : super(key: key);

  final Function(StarterAd) onCloseTapped;
  final Function(StarterAd)? onBodyTapped;
  final StarterAd ad;

  @override
  State<InitialAd> createState() => _InitialAdState();
}

class _InitialAdState extends State<InitialAd> {
  late final MyAudioPlayer audioPlayer;

  @override
  void initState() {
    audioPlayer = MyAudioPlayer()..playAdPopUpSound();
    super.initState();
  }

  static const double AD_HEIGHT = 300;
  static const double AD_WIDTH = 300;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - (AD_WIDTH / 2),
      top: MediaQuery.of(context).size.height / 2 - (AD_HEIGHT / 2),
      child: Container(
        key: Key(widget.ad.uuid),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        color: MyColors.primary,
        height: AD_HEIGHT,
        width: AD_WIDTH,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (widget.onBodyTapped != null) {
                      widget.onBodyTapped!(widget.ad);
                    }
                    MyAudioPlayer().playAdMissedSound();
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'You are the Ad Killer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Avoid taping ad body',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () async {
                    HapticFeedback.vibrate();
                    await audioPlayer.playAdSlainSound();
                    return widget.onCloseTapped(widget.ad);
                  },
                )),
            const Positioned(
              top: 18,
              right: 50,
              child: Row(children: [
                Text('Kill all the ads'),
                Icon(Icons.arrow_forward_outlined),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class TextPopUpAd extends StatefulWidget {
  const TextPopUpAd(
      {required this.ad,
      required this.onCloseTapped,
      this.onAdBodyTapped,
      Key? key})
      : super(key: key);

  final Function(TextAd) onCloseTapped;
  final Function(TextAd)? onAdBodyTapped;
  final TextAd ad;

  static const int MIN_AD_WIDTH = 150;
  static const int MAX_AD_WIDTH = 200;

  static const int MIN_AD_HEIGHT = 110;
  static const int MAX_AD_HEIGHT = 200;

  @override
  State<TextPopUpAd> createState() => _TextPopUpAdState();
}

class _TextPopUpAdState extends State<TextPopUpAd> {
  late double _width = 0;
  late double _height = 0;
  late Color _bgColor;
  late Color _textColor;
  late Color _accentsColor;

  late final MyAudioPlayer audioPlayer;

  @override
  void initState() {
    audioPlayer = MyAudioPlayer()..playAdPopUpSound();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bgColor = getRandomValueFromList(Colors.primaries)
        .withAlpha(getRandomInt(min: 210, max: 255));
    _textColor = getRandomValueFromList(Colors.accents);
    _accentsColor = getRandomValueFromList(Colors.accents);
    Future.delayed(Duration.zero, () {
      setState(() {
        _width = getRandomInt(
                min: TextPopUpAd.MIN_AD_WIDTH, max: TextPopUpAd.MAX_AD_WIDTH)
            .toDouble();
        _height = getRandomInt(
                min: TextPopUpAd.MIN_AD_HEIGHT, max: TextPopUpAd.MAX_AD_HEIGHT)
            .toDouble();
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RandomPositionWidget(
      child: AnimatedContainer(
        key: Key(widget.ad.uuid),
        width: _width,
        height: _height,
        color: _bgColor,
        duration: Duration(milliseconds: getRandomInt(min: 300, max: 500)),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    MyAudioPlayer().playAdMissedSound();
                    if (widget.onAdBodyTapped != null) {
                      widget.onAdBodyTapped!(widget.ad);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.ad.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.ad.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _textColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: _accentsColor,
                  ),
                  onPressed: () async {
                    HapticFeedback.vibrate();
                    await audioPlayer.playAdSlainSound();
                    return widget.onCloseTapped(widget.ad);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
