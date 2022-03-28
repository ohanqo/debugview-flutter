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
}
