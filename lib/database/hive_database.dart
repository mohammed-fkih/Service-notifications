import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {
  Box<Map<String, dynamic>>? _box;

  Future<void> initialize() async {
    if (!Hive.isBoxOpen('element')) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      _box = await Hive.openBox<Map<String, dynamic>>('element');
    } else {
      _box = Hive.box<Map<String, dynamic>>('element');
    }
  }

  Future<void> addItem(Map<String, dynamic> map) async {
    await _box!.add(map);
  }

  Future<void> removeItem(String key) async {
    await _box!.delete(key);
  }

  Future<void> updateItem(String key, dynamic newValue) async {
    if (_box!.containsKey(key)) {
      await _box!.put(key, newValue);
    }
  }

  Future<dynamic> getItem(String key) async {
    return _box!.get(key);
  }
}
