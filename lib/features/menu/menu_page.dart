import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;

import '../../core/domain/my_audio_player.dart';
import '../../core/presentation/base_page.dart';
import '../../core/routes.dart';
import '../ad_mob/ad_mob.dart';
import '../ad_mob/ad_mob_ads.dart';
import '../game/data/ad.dart';
import '../game/domain/ad_content_generator.dart';
import '../game/presentation/widgets/pop_up_ad.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Ad> bgAds = [];
  late final AdGenerator adGenerator;
  late final AudioPlayer audioPlayer;

  late final google_ads.BannerAd bannerAdTop;
  late final google_ads.BannerAd bannerAdBottom;

  @override
  void initState() {
    bannerAdTop = AdMob.instance.getMenuBannerAdTop();
    bannerAdBottom = AdMob.instance.getMenuBannerAdBottom();
    adGenerator = AdGenerator(AdContentGenerator())..startGeneratingAds();
    adGenerator.$generatedAd.listen((ads) {
      if (bgAds.length > 50) {
        bgAds.clear();
      }
      setState(() {
        bgAds.add(ads);
      });
    });
    MyAudioPlayer()
        .playLoopedMainMenuMusic()
        .then((value) => audioPlayer = value);
    super.initState();
  }

  @override
  void dispose() {
    adGenerator.stopGeneratingAds();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  void deactivate() {
    audioPlayer.stop();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        child: Scaffold(
      body: Stack(
        children: [
          ...bgAds.map((ad) => AdBodyGenerator(
                key: Key(ad.uuid),
                ad: ad,
                onCloseTapped: (ad) {
                  setState(() {
                    bgAds.remove(ad);
                  });
                },
                onAdBodyTapped: (ad) {},
              )),
          Positioned.fill(
            child: Center(
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ad Killer Simulator',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.combine(
                                [TextDecoration.underline]),
                            decorationStyle: TextDecorationStyle.solid,
                            decorationThickness: 2,
                            fontSize: 24)),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 240,
                      child: ElevatedButton(
                        child: const Text('Start Game'),
                        onPressed: () async {
                          final route = gameRoute();
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 240,
                      child: ElevatedButton(
                        child: const Text('Settings'),
                        onPressed: () {
                          Navigator.pushReplacement(context, settingsRoute());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 1,
            left: 1,
            right: 1,
            child: AdMobBannerAd(adMobAd: bannerAdTop),
          ),
          Positioned(
            bottom: 1,
            left: 1,
            right: 1,
            child: AdMobBannerAd(adMobAd: bannerAdBottom),
          ),
        ],
      ),
    ));
  }
}
