import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Prefs _singleton = Prefs._internal();

  factory Prefs() => _singleton;

  Prefs._internal();

  late SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool? getBool(String id) {
    return prefs.getBool(id);
  }

  setBool({required String id, required bool value}) async {
    await prefs.setBool(id, value);
  }

  int getInt(String id) => prefs.getInt(id) ?? 0;

  setInt({required String id, required int value}) async {
    await prefs.setInt(id, value);
  }
}
