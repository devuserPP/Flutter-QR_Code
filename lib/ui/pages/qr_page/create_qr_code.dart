import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
            const SizedBox(height: 25)
          ],
        ),
      ),
    );
  }
}
