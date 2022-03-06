import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import '../../../core/controllers/app_controller.dart';
import '../../../core/services/appodealAds_services.dart';

import '../../../routes.dart';

int _pressBackButtonCounter = 0;

class QrCode extends StatelessWidget {
  final qrKey = GlobalKey();

  void takeScreenShot() async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${DateTime.now()}${AppController.to.qrData!}.png',
        );
        imgFile.writeAsBytes(pngBytes);
        GallerySaver.saveImage(imgFile.path).then(
          (success) async {
            await AppController.to.createQr(AppController.to.qrData!);

            Get.toNamed(Routes.home);

            //Get.back();
            if (ApodealAds()
                .showAdsEverySecondTime(_pressBackButtonCounter++)) {
              ApodealAds().showInterstitialAd();
            }
          },
        );
      }
    }
  }

  void deletecreenShot() async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final directory = (await getApplicationDocumentsDirectory()).path;
      final imgFile = File(
        '$directory/${DateTime.now()}${AppController.to.qrData!}.png',
      );
      try {
        await imgFile.delete();
      } catch (e) {
        Get.toNamed(Routes.createQR);
        return;
      }
    }
    Get.toNamed(Routes.createQR);
    //Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final qrData = AppController.to.qrData;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            Center(
              child: RepaintBoundary(
                key: qrKey,
                child: QrImage(
                  data: qrData!,
                  size: 250,
                  backgroundColor: Colors.white,
                  version: QrVersions.auto,
                ),
              ),
            ),
            const SizedBox(height: 25),
            CupertinoButton(child: Text("Save"), onPressed: takeScreenShot),
            const SizedBox(height: 25),
            // IconButton(
            //   icon: Icon(Icons.delete),
            //   iconSize: 24.0,
            //   color: Colors.red,
            //   onPressed: () {
            //     deletecreenShot();
            //   },
            // ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: true,
                  child: AppodealBanner(
                      adSize: AppodealBannerSize.BANNER, placement: "default"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
