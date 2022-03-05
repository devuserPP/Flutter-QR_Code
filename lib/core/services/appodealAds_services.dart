import 'dart:async';

import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

// https://github.com/appodeal/Appodeal-Flutter-Plugin/blob/main/example/lib/consent_manager.dart

class ApodealAds {
  String appodealAppKey = "49bcb9608cdad780462cb67a26d6674b670a93e0c7898ada";
  String userConsent = '';

  // ApodealAds({required this.appodealAppKey, required this.hasUserConsent});

  String get appKey {
    return appodealAppKey;
  }

  Future<void> appodealInit(
      {required String userConsent, required bool isTested}) async {
    //To disable automatic caching for interstitials
    Appodeal.setAutoCache(Appodeal.INTERSTITIAL, false);

    // for testing
    if (isTested) {
      Appodeal.setLogLevel(Appodeal.LogLevelVerbose);
      Appodeal.setTesting(true);
    }

    // TODO: K cemu to je?
    Appodeal.setTriggerOnLoadedOnPrecache(Appodeal.INTERSTITIAL, true);

    //Setting Ads
    Appodeal.setSharedAdsInstanceAcrossActivities(true);
    Appodeal.muteVideosIfCallsMuted(true);
    Appodeal.disableNetwork("admob");
    Appodeal.setBannerAnimation(true);

    //set manual cashing
    Appodeal.setAutoCache(Appodeal.INTERSTITIAL, false);

    bool myConsent = (userConsent == 'TRUE') ? true : false;

    Appodeal.initialize(
      ApodealAds().appKey,
      [
        Appodeal.INTERSTITIAL,
        Appodeal.BANNER,
      ],
    );
  }

  void loadNextInterstitialAd() {
    Appodeal.cache(Appodeal.INTERSTITIAL);
    Appodeal.getPredictedEcpm(Appodeal.INTERSTITIAL);
  }

  Future<bool> showInterstitialAd() async {
    return await Appodeal.canShow(Appodeal.INTERSTITIAL).then(
      (value) async {
        await Appodeal.show(Appodeal.INTERSTITIAL, "default");
        Appodeal.cache(Appodeal.INTERSTITIAL);
        Appodeal.getPredictedEcpm(Appodeal.INTERSTITIAL);
        return true;
      },
      onError: (error) {
        loadNextInterstitialAd();
        return false;
      },
    );
  }

  bool showAdsEverySecondTime(int pressBackButtonCounter) {
    return pressBackButtonCounter.isOdd ? true : false;
  }

  Future<void> resolveUserConsent() async {
    ConsentManager.showAsDialogConsentForm();

    // var shouldShowConsentDialog =
    //     await ConsentManager.shouldShowConsentDialog();

    // if ((shouldShowConsentDialog == ShouldShow.TRUE) ||
    //     (shouldShowConsentDialog == ShouldShow.UNKNOWN)) {
    //   await ConsentManager.loadConsentForm();
    //   await ConsentManager.showAsDialogConsentForm();
    //    {
    appodealInit(userConsent: 'TRUE', isTested: false);
    //  }
  }

  // ConsentManager.setConsentFormListener(
  //     (onConsentFormLoaded) => {ConsentManager.showAsDialogConsentForm()},
  //     (onConsentFormError, error) => {},
  //     (onConsentFormOpened) => {},
  //     (onConsentFormClosed, consent) =>
  //         {appodealInit(userConsent: consent, isTested: true)});
}
