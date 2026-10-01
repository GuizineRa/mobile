import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/punch_record_model.dart';
import '../models/work_location_model.dart';

class StorageService {
  static const String _keyCurrentUser = 'current_user';
  static const String _keyPunchRecords = 'punch_records';
  static const String _keyWorkLocation = 'work_location';
  static const String _keyBiometricAuthRemembered = 'biometric_remembered';

  Future<void> saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentUser, user.toJson());
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyCurrentUser);
    if (jsonStr == null) return null;
    try {
      return UserModel.fromJson(jsonStr);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUser);
  }

  Future<void> savePunchRecords(List<PunchRecordModel> records) async {
    final prefs = await SharedPreferences.getInstance();
    final list = records.map((r) => r.toMap()).toList();
    await prefs.setString(_keyPunchRecords, json.encode(list));
  }

  Future<List<PunchRecordModel>> getPunchRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyPunchRecords);
    if (jsonStr == null) return [];
    try {
      final List decoded = json.decode(jsonStr);
      return decoded.map((item) => PunchRecordModel.fromMap(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addPunchRecord(PunchRecordModel record) async {
    final records = await getPunchRecords();
    records.insert(0, record);
    await savePunchRecords(records);
  }

  Future<void> saveWorkLocation(WorkLocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWorkLocation, location.toJson());
  }

  Future<WorkLocationModel?> getWorkLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyWorkLocation);
    if (jsonStr == null) return null;
    try {
      return WorkLocationModel.fromJson(jsonStr);
    } catch (e) {
      return null;
    }
  }

  Future<void> setBiometricRemembered(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricAuthRemembered, value);
  }

  Future<bool> isBiometricRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyBiometricAuthRemembered) ?? false;
  }
}
