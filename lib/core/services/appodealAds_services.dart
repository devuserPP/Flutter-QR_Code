import 'dart:async';

import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

// https://github.com/appodeal/Appodeal-Flutter-Plugin/blob/main/example/lib/consent_manager.dart

class ApodealAds {
  String appodealAppKey = "1bb4f0a9c7d31bae651f2c1f3bc92eac28a96fcd1c4b49cb";
  String userConsent = '';

  // ApodealAds({required this.appodealAppKey, required this.hasUserConsent});

  String get appKey {
    return appodealAppKey;
  }

  Future<void> appodealInit(
      {required String userConsent, required bool isTested}) async {
    // for testing
    if (isTested) {
      Appodeal.setLogLevel(Appodeal.LogLevelVerbose);
      Appodeal.setTesting(true);
    }

    //Setting Ads
    Appodeal.setTriggerOnLoadedOnPrecache(Appodeal.INTERSTITIAL, true);
    Appodeal.setSharedAdsInstanceAcrossActivities(true);
    Appodeal.setSmartBanners(false);
    Appodeal.setTabletBanners(false);
    Appodeal.setBannerAnimation(false);
    Appodeal.disableNetwork("admob");
    Appodeal.disableNetworkForSpecificAdType("vungle", Appodeal.INTERSTITIAL);

    bool myConsent = (userConsent == 'TRUE') ? true : false;

    Appodeal.initialize(
        ApodealAds().appKey,
        [
          Appodeal.INTERSTITIAL,
          Appodeal.BANNER,
        ],
        myConsent);
  }

  Future<bool> showInterstitialAd() async {
    return await Appodeal.canShow(Appodeal.INTERSTITIAL).then(
      (value) async {
        await Appodeal.showWithPlacement(Appodeal.INTERSTITIAL, 'default');
        return true;
      },
      onError: (error) {
        return false;
      },
    );
  }

  bool showAdsEverySecondTime(int pressBackButtonCounter) {
    return pressBackButtonCounter.isOdd ? true : false;
  }
}
