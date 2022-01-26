import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  static StorageService get to => Get.find();

  final _box = GetStorage();

  void writeIfNull(String key, dynamic value) {
    _box.writeIfNull(key, value);
  }

  void write(String key, dynamic value) {
    _box.write(key, value);
  }

  dynamic read(String key) {
    return _box.read(key);
  }

  void remove(String key) {
    _box.remove(key);
  }

  void listen(String key, Function callback) {
    _box.listenKey(key, callback as dynamic Function(dynamic));
  }
}
