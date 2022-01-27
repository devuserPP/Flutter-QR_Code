import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'binds.dart';
import 'init.dart';
import 'routes.dart';

import 'core/services/appodealAds_services.dart';

void main() async {
  await init();

  //Appodeal init
  await ApodealAds().appodealInit(userConsent: "TRUE", isTested: false);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QR Code",
      getPages: Routes.getPages,
      initialBinding: Binds(),
    );
  }
}
