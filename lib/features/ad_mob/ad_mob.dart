import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMob {
  AdMob._();

  static final AdMob _instance = AdMob._();

  static AdMob get instance => _instance;

  Future<void> init() async {
    try {
      await MobileAds.instance.initialize().then((value) => () {
            debugPrint(value.toString());
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///Must be called in INIT STATE
  BannerAd getMenuBannerAdTop() {
    //Demo ad:  	ca-app-pub-3940256099942544/6300978111
    return _loadBannerAd('ca-app-pub-3940256099942544/6300978111');
  }

  ///Must be called in INIT STATE
  BannerAd getMenuBannerAdBottom() {
    //Demo ad:  	ca-app-pub-3940256099942544/6300978111
    return _loadBannerAd('ca-app-pub-3940256099942544/6300978111');
  }

  /// Use .show() to show full screen ad
  Future<InterstitialAd?> getRepeatGameFullScreenAd() async {
    // Demo ad 'ca-app-pub-3940256099942544/1033173712'
    InterstitialAd? loadedAd;
    await InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            loadedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint(error.message);
          },
        ));
    await Future.delayed(const Duration(seconds: 1));
    loadedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
    );

    return loadedAd;
  }

  BannerAd _loadBannerAd(String adUnitId) {
    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        debugPrint(error.message);
        ad.dispose();
      }),
    )..load();
  }
}
