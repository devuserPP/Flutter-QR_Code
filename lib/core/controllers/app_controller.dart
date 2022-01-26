import 'package:get/get.dart';

import '../services/storage_service.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  String? qrData;

  List createdQrs = [];
  List scannedQrs = [];

  @override
  void onInit() {
    super.onInit();
    createdQrs = StorageService.to.read('createdQrList') ?? [];
    scannedQrs = StorageService.to.read('scannedQrList') ?? [];
  }

  Future<void> createQr(String data) async {
    List tempList = StorageService.to.read('createdQrList') ?? [];
    StorageService.to.write('createdQrList', [...tempList, data]);
    createdQrs.add(data);
    update();
  }

  Future<void> scanQr(String data) async {
    List tempList = StorageService.to.read('scannedQrList') ?? [];
    StorageService.to.write('scannedQrList', [...tempList, data]);
    scannedQrs.add(data);
    update();
  }
}
