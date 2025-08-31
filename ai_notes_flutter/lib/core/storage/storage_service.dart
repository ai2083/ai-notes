import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class StorageService {
  static Box? _notesBox;
  static Box? _foldersBox;
  static Box? _settingsBox;

  static Future<void> init() async {
    // 初始化Hive
    await Hive.initFlutter();
    
    // 注册适配器（如果有自定义类型）
    // Hive.registerAdapter(NoteAdapter());
    
    // 打开数据库
    _notesBox = await Hive.openBox(AppConstants.notesBoxName);
    _foldersBox = await Hive.openBox(AppConstants.foldersBoxName);
    _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
  }

  // 笔记相关操作
  static Box get notesBox {
    if (_notesBox == null) {
      throw Exception('Notes box not initialized. Call StorageService.init() first.');
    }
    return _notesBox!;
  }

  // 文件夹相关操作
  static Box get foldersBox {
    if (_foldersBox == null) {
      throw Exception('Folders box not initialized. Call StorageService.init() first.');
    }
    return _foldersBox!;
  }

  // 设置相关操作
  static Box get settingsBox {
    if (_settingsBox == null) {
      throw Exception('Settings box not initialized. Call StorageService.init() first.');
    }
    return _settingsBox!;
  }

  // 通用存储操作
  static Future<void> put(String boxName, String key, dynamic value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  static T? get<T>(String boxName, String key, {T? defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  static Future<void> delete(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
  }

  static Future<void> clear(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }

  // 清理所有数据
  static Future<void> clearAll() async {
    await Future.wait([
      _notesBox?.clear() ?? Future.value(),
      _foldersBox?.clear() ?? Future.value(),
      _settingsBox?.clear() ?? Future.value(),
    ]);
  }

  // 关闭所有数据库
  static Future<void> closeAll() async {
    await Future.wait([
      _notesBox?.close() ?? Future.value(),
      _foldersBox?.close() ?? Future.value(),
      _settingsBox?.close() ?? Future.value(),
    ]);
  }
}
