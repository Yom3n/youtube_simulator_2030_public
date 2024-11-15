import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobBannerAd extends StatelessWidget {
  const AdMobBannerAd({Key? key, required this.adMobAd}) : super(key: key);
  final BannerAd adMobAd;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: adMobAd.size.width.toDouble(),
        height: adMobAd.size.height.toDouble(),
        child: AdWidget(ad: adMobAd));
  }
}
