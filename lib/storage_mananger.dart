import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class StorageManager {
  final GetStorage _storage = GetStorage();

  // Lưu trữ dữ liệu
  Future<void> saveData(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Lấy dữ liệu
  T? getData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Kiểm tra tồn tại của key
  bool containsKey(String key) {
    return _storage.hasData(key);
  }

  // Xóa dữ liệu
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Xóa toàn bộ dữ liệu
  Future<void> clearAll() async {
    await _storage.erase();
  }

  // Lưu object dưới dạng JSON
  Future<void> saveObject(String key, dynamic object) async {
    String jsonString = jsonEncode(object);
    await _storage.write(key, jsonString);
  }

  // Lấy object từ JSON
  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    String? jsonString = _storage.read<String>(key);
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return fromJson(jsonMap);
    }
    return null;
  }

  // Lưu danh sách object
  Future<void> saveObjectList<T>(String key, List<T> objectList) async {
    List<String> jsonList = objectList.map((obj) => jsonEncode(obj)).toList();
    await _storage.write(key, jsonList);
  }

  // Lấy danh sách object
  List<T>? getObjectList<T>(
      String key, T Function(Map<String, dynamic>) fromJson) {
    List<dynamic>? jsonList =
        _storage.read<List<dynamic>>(key); // Đọc từ storage
    if (jsonList != null) {
      // Chuyển đổi từ List<dynamic> sang List<T>
      return jsonList.map((jsonString) {
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return fromJson(jsonMap);
      }).toList();
    }
    return null;
  }
}
