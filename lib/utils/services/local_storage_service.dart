/// In this file shared_preference plugin is used to store the
/// data locally in the application
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Singleton class
class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  LocalStorageService._internal();

  static Future<LocalStorageService?> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  /// Getters and Setters for eventsList
  Map<String, dynamic> get eventsList {
    String? _eventsList = _getDataFromDisk("EVENTS");

    if (_eventsList != null) {
      return jsonDecode(_eventsList);
    } else {
      return {"years": []};
    }
  }

  set eventsList(Map<String, dynamic> value) {
    String _value = jsonEncode(value);
    _saveDataToDisk("EVENTS", _value);
  }

  /// This function gets the data from the disk
  dynamic _getDataFromDisk(String key) => _preferences?.get(key);

  /// This function saves the data on the disk
  void _saveDataToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences?.setString(key, content);
    } else if (content is bool) {
      _preferences?.setBool(key, content);
    } else if (content is int) {
      _preferences?.setInt(key, content);
    } else if (content is double) {
      _preferences?.setDouble(key, content);
    } else if (content is List<String>) {
      _preferences?.setStringList(key, content);
    } else {
      _preferences?.setString(key, content.toString());
    }
  }
}
