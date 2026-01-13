import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notulensi.dart';
import '../models/dokumen.dart';

class StorageService {
  static const String _keyNotulensi = 'notulensi_list';
  static const String _keyDokumen = 'dokumen_list';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'username';

  // Auth Methods
  Future<void> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Simple validation - in production, use proper authentication
    if (username.isNotEmpty && password.isNotEmpty) {
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUsername, username);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUsername);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Notulensi Methods
  Future<List<Notulensi>> getNotulensiList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_keyNotulensi);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Notulensi.fromJson(json)).toList();
  }

  Future<void> saveNotulensi(Notulensi notulensi) async {
    final list = await getNotulensiList();
    final index = list.indexWhere((n) => n.id == notulensi.id);

    if (index != -1) {
      list[index] = notulensi;
    } else {
      list.add(notulensi);
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(list.map((n) => n.toJson()).toList());
    await prefs.setString(_keyNotulensi, jsonString);
  }

  Future<void> deleteNotulensi(String id) async {
    final list = await getNotulensiList();
    list.removeWhere((n) => n.id == id);

    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(list.map((n) => n.toJson()).toList());
    await prefs.setString(_keyNotulensi, jsonString);
  }

  // Dokumen Methods
  Future<List<Dokumen>> getDokumenList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_keyDokumen);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Dokumen.fromJson(json)).toList();
  }

  Future<void> saveDokumen(Dokumen dokumen) async {
    final list = await getDokumenList();
    final index = list.indexWhere((d) => d.id == dokumen.id);

    if (index != -1) {
      list[index] = dokumen;
    } else {
      list.add(dokumen);
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(list.map((d) => d.toJson()).toList());
    await prefs.setString(_keyDokumen, jsonString);
  }

  Future<void> deleteDokumen(String id) async {
    final list = await getDokumenList();
    list.removeWhere((d) => d.id == id);

    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(list.map((d) => d.toJson()).toList());
    await prefs.setString(_keyDokumen, jsonString);
  }

  // Statistics Methods
  Future<Map<String, int>> getStatistics() async {
    final notulensiList = await getNotulensiList();
    final dokumenList = await getDokumenList();

    final proposalCount = dokumenList
        .where((d) => d.jenis == JenisDokumen.proposal)
        .length;
    final lpjCount = dokumenList
        .where((d) => d.jenis == JenisDokumen.lpj)
        .length;
    final selesaiCount = dokumenList
        .where((d) => d.status == StatusDokumen.selesai)
        .length;
    final prosesCount = dokumenList
        .where((d) => d.status == StatusDokumen.proses)
        .length;
    final kendalaCount = dokumenList
        .where((d) => d.status == StatusDokumen.kendala)
        .length;

    return {
      'totalNotulensi': notulensiList.length,
      'totalDokumen': dokumenList.length,
      'proposal': proposalCount,
      'lpj': lpjCount,
      'selesai': selesaiCount,
      'proses': prosesCount,
      'kendala': kendalaCount,
    };
  }
}
