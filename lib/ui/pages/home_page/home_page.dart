import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/controllers/app_controller.dart';
import '../../../routes.dart';

import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final index = useState(0);
    final tabController = useTabController(initialLength: 2);
    final qrdata = useTextEditingController();
    tabController.addListener(() => index.value = tabController.index);
    // Show banner Ad
    Appodeal.show(Appodeal.BANNER_BOTTOM);
    return GetBuilder<AppController>(
      builder: (c) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  index.value == 1
                      ? CupertinoButton(
                          child: Text('Create Qr'),
                          onPressed: () => Get.defaultDialog(
                            title: "Your Data",
                            content: Column(
                              children: [
                                TextField(controller: qrdata, autofocus: true),
                                const SizedBox(height: 20),
                                CupertinoButton(
                                  child: Text('Create Qr'),
                                  onPressed: () {
                                    c.qrData = qrdata.text;
                                    Get.offNamed(Routes.createQR);
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      : CupertinoButton(
                          child: Text('Scan Qr'),
                          onPressed: () => Get.toNamed(Routes.scanQR),
                        )
                ],
              ),
              bottom: TabBar(
                controller: tabController,
                isScrollable: true,
                indicatorWeight: 4,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black87,
                tabs: [
                  Tab(text: 'Scans'),
                  Tab(text: 'History'),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                c.scannedQrs.isEmpty
                    ? Center(
                        child: Text("There isn't any scanned Qr's yet."),
                      )
                    : ListView.builder(
                        itemCount: c.scannedQrs.length,
                        itemBuilder: (_, i) => GestureDetector(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  QrImage(
                                    data: c.scannedQrs[i],
                                    size: 75,
                                    backgroundColor: Colors.white,
                                    version: QrVersions.auto,
                                  ),
                                  Text(c.scannedQrs[i]),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            c.qrData = c.scannedQrs[i];
                            Get.offNamed(Routes.createQR);
                          },
                        ),
                      ),
                c.createdQrs.isEmpty
                    ? Center(
                        child: Text("There isn't any created Qr's yet."),
                      )
                    : ListView.builder(
                        itemCount: c.createdQrs.length,
                        itemBuilder: (_, i) => GestureDetector(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  QrImage(
                                    data: c.createdQrs[i],
                                    size: 75,
                                    backgroundColor: Colors.white,
                                    version: QrVersions.auto,
                                  ),
                                  Text(c.createdQrs[i]),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            c.qrData = c.createdQrs[i];
                            Get.offNamed(Routes.createQR);
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
