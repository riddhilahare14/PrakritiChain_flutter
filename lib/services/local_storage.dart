import 'package:hive/hive.dart';

class LocalStorage {
  static Box get _box => Hive.box('pending_collections');

  static Future<void> addPending(Map<String, dynamic> json) async {
    await _box.add(json);
  }

  static List<Map> getAllPending() {
    return _box.values.cast<Map>().toList();
  }

  static Future<void> removeAt(int index) async {
    await _box.deleteAt(index);
  }

  static int get length => _box.length;
}
