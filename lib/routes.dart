import 'package:get/get.dart';

import 'ui/pages/home_page/home_page.dart';
import 'ui/pages/qr_page/create_qr_code.dart';
import 'ui/pages/qr_page/scan_qr_page.dart';

class Routes {
  static const String home = '/';
  static const String scanQR = '/scan-qr';
  static const String createQR = '/create-qr';

  static final List<GetPage> getPages = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: scanQR, page: () => ScanQrPage()),
    GetPage(name: createQR, page: () => QrCode()),
  ];
}
